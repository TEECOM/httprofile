package profile

import (
	"context"
	"crypto/tls"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"net/http/httptrace"
	"time"
)

type resultResponse struct {
	Protocol string            `json:"protocol"`
	Status   int               `json:"status"`
	Headers  map[string]string `json:"headers"`
	Body     string            `json:"body"`

	DNSLookupDuration        time.Duration `json:"dnsLookupDuration"`
	TCPConnectionDuration    time.Duration `json:"tcpConnectionDuration"`
	TLSHandshakeDuration     time.Duration `json:"tlsHandshakeDuration"`
	ServerProcessingDuration time.Duration `json:"serverProcessingDuration"`
	ContentTransferDuration  time.Duration `json:"contentTransferDuration"`

	TimeToNameLookup    time.Duration `json:"timeToNameLookup"`
	TimeToConnect       time.Duration `json:"timeToConnect"`
	TimeToPreTransfer   time.Duration `json:"timeToPreTransfer"`
	TimeToStartTransfer time.Duration `json:"timeToStartTransfer"`
	TotalRequestTime    time.Duration `json:"totalRequestTime"`
}

type Result struct {
	DNSLookup        time.Duration
	TCPConnection    time.Duration
	TLSHandshake     time.Duration
	ServerProcessing time.Duration
	ContentTransfer  time.Duration
	NameLookup       time.Duration
	Connect          time.Duration
	PreTransfer      time.Duration
	StartTransfer    time.Duration
	Total            time.Duration

	response *http.Response
}

func (res Result) Body() string {
	body, _ := ioutil.ReadAll(res.response.Body)

	return string(body)
}

func (res Result) Headers() map[string]string {
	headers := map[string]string{}

	for k, v := range res.response.Header {
		headers[k] = v[0]
	}

	return headers
}

func (res *Result) Close() {
	res.response.Body.Close()
}

func (res Result) MarshalJSON() ([]byte, error) {
	record := resultResponse{
		Protocol:                 res.response.Proto,
		Status:                   res.response.StatusCode,
		Headers:                  res.Headers(),
		Body:                     res.Body(),
		DNSLookupDuration:        res.DNSLookup,
		TCPConnectionDuration:    res.TCPConnection,
		TLSHandshakeDuration:     res.TLSHandshake,
		ServerProcessingDuration: res.ServerProcessing,
		ContentTransferDuration:  res.ContentTransfer,
		TimeToNameLookup:         res.NameLookup,
		TimeToConnect:            res.Connect,
		TimeToPreTransfer:        res.PreTransfer,
		TimeToStartTransfer:      res.StartTransfer,
		TotalRequestTime:         res.Total,
	}

	return json.Marshal(record)
}

func Run(req *http.Request) (*Result, error) {
	var t0, t1, t2, t3, t4, t5, t6, t7 time.Time
	var connErr error

	trace := &httptrace.ClientTrace{
		DNSStart: func(_ httptrace.DNSStartInfo) { t0 = time.Now() },
		DNSDone:  func(_ httptrace.DNSDoneInfo) { t1 = time.Now() },
		ConnectStart: func(_, _ string) {
			if t1.IsZero() {
				t1 = time.Now()
			}
		},
		ConnectDone: func(net, addr string, err error) {
			if err != nil {
				connErr = err
			}

			t2 = time.Now()
		},
		GotConn:              func(_ httptrace.GotConnInfo) { t3 = time.Now() },
		GotFirstResponseByte: func() { t4 = time.Now() },
		TLSHandshakeStart:    func() { t5 = time.Now() },
		TLSHandshakeDone:     func(_ tls.ConnectionState, _ error) { t6 = time.Now() },
	}

	req = req.WithContext(httptrace.WithClientTrace(context.Background(), trace))

	resp, err := http.DefaultTransport.RoundTrip(req)
	if err != nil {
		return nil, err
	}
	if connErr != nil {
		return nil, connErr
	}

	t0 = earliestOf(t0, t1, t2, t3)
	t1 = earliestOf(t1, t2, t3)
	t2 = earliestOf(t2, t3)

	t7 = time.Now()

	result := &Result{
		DNSLookup:        t1.Sub(t0),
		TCPConnection:    t2.Sub(t1),
		TLSHandshake:     t6.Sub(t5),
		ServerProcessing: t4.Sub(t3),
		ContentTransfer:  t7.Sub(t4),
		NameLookup:       t1.Sub(t0),
		Connect:          t2.Sub(t0),
		PreTransfer:      t3.Sub(t0),
		StartTransfer:    t4.Sub(t0),
		Total:            t7.Sub(t0),
		response:         resp,
	}

	return result, nil
}

func earliestOf(times ...time.Time) time.Time {
	for _, time := range times {
		if !time.IsZero() {
			return time
		}
	}

	return times[len(times)-1]
}
