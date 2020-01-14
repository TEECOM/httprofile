package middleware

import (
	"net/http"
	"strings"
)

type Middleware func(http.HandlerFunc) http.HandlerFunc

func RequireMethod(methods ...string) Middleware {
	return func(h http.HandlerFunc) http.HandlerFunc {
		return func(w http.ResponseWriter, r *http.Request) {
			if !contains(methods, r.Method) {
				w.Header().Set("Allow", strings.Join(methods, ", "))
				http.Error(
					w,
					http.StatusText(http.StatusMethodNotAllowed),
					http.StatusMethodNotAllowed,
				)
				return
			}

			h(w, r)
		}
	}
}

func contains(strs []string, str string) bool {
	for _, v := range strs {
		if v == str {
			return true
		}
	}
	return false
}
