package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strings"

	"httprofile/src/backend/log"
	"httprofile/src/backend/middleware"
	"httprofile/src/backend/profile"

	"github.com/rs/xid"
)

type server struct {
	router *http.ServeMux
}

func newServer() *server {
	server := &server{router: http.NewServeMux()}
	server.routes()
	return server
}

func (s *server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")

	if r.Method == http.MethodOptions {
		w.Header().Set("Access-Control-Allow-Methods", "*")
		w.Header().Set("Access-Control-Allow-HEADERS", "Content-Type")
		w.WriteHeader(http.StatusNoContent)
		return
	}

	s.router.ServeHTTP(w, r)
}

func (s *server) routes() {
	s.router.HandleFunc(
		"/report",
		middleware.RequireMethod(http.MethodPost)(s.handleReport()),
	)
}

func (s *server) handleReport() http.HandlerFunc {
	type request struct {
		Method  string            `json:"method"`
		URL     string            `json:"url"`
		Headers map[string]string `json:"headers"`
		Body    string            `json:"body"`
	}

	return func(w http.ResponseWriter, r *http.Request) {
		var profReq request
		if err := s.decode(w, r, &profReq); err != nil {
			s.error(
				w,
				r,
				http.StatusBadRequest,
				"UnparseableBody",
				fmt.Sprintf("Something is off with the request body: %s.", err),
				err,
			)
			return
		}

		url, err := parseURL(profReq.URL)
		if err != nil {
			s.error(
				w,
				r,
				http.StatusBadRequest,
				"InvalidURL",
				"The included URL wasn't parseable.",
				err,
			)
			return
		}

		req, err := newRequest(profReq.Method, url, profReq.Headers, profReq.Body)
		if err != nil {
			s.error(
				w,
				r,
				http.StatusBadRequest,
				"InvaldRequestSpecification",
				fmt.Sprintf("The provided request details are invalid: %s.", err),
				err,
			)
			return
		}

		result, err := profile.Run(req)
		if err != nil {
			s.error(
				w,
				r,
				http.StatusInternalServerError,
				"ProfilingFailed",
				"Something went wrong on our end trying to run a profile.",
				err,
			)
			return
		}

		log.SuccessfulProfile(profReq.URL)
		s.respond(w, r, result, 200)
	}
}

func parseURL(uri string) (*url.URL, error) {
	if !strings.Contains(uri, "://") && !strings.HasPrefix(uri, "//") {
		uri = "//" + uri
	}

	url, err := url.Parse(uri)
	if err != nil {
		return nil, err
	}

	if url.Scheme == "" {
		url.Scheme = "https"
		if strings.HasSuffix(url.Host, ":80") {
			url.Scheme = "http"
		}
	}

	return url, nil
}

func newRequest(method string, url *url.URL, headers map[string]string, body string) (*http.Request, error) {
	header := http.Header{}
	for k, v := range headers {
		header.Set(k, v)
	}

	req, err := http.NewRequest(method, url.String(), strings.NewReader(body))
	if err != nil {
		return nil, err
	}
	req.Header = header

	return req, nil
}

type errorResponse struct {
	Status  int    `json:"status"`
	Type    string `json:"type"`
	Message string `json:"message"`
	TraceID xid.ID `json:"traceID"`
}

func (s *server) respond(w http.ResponseWriter, r *http.Request, data interface{}, status int) {
	var response []byte
	var err error

	if data != nil {
		response, err = json.Marshal(data)
		if err != nil {
			status = http.StatusInternalServerError

			traceID := log.Error(err)
			response, _ = json.Marshal(map[string]errorResponse{
				"error": {
					Status:  status,
					Type:    "MarshalingError",
					Message: "Unable to marshal JSON response.",
					TraceID: traceID,
				},
			})
		}
	}

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	w.Write(response)
}

func (s *server) error(w http.ResponseWriter, r *http.Request, status int, t string, message string, err error) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)

	traceID := log.Error(err)
	json.NewEncoder(w).Encode(map[string]errorResponse{
		"error": {
			Status:  status,
			Type:    t,
			Message: message,
			TraceID: traceID,
		},
	})
}

func (s *server) decode(w http.ResponseWriter, r *http.Request, v interface{}) error {
	return json.NewDecoder(r.Body).Decode(v)
}
