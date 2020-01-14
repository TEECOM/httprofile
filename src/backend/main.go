package main

import (
	"net/http"
	"os"

	"httprofile/src/backend/log"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		log.Info("$PORT not set... falling back to '8080'.")
		port = "8080"
	}

	log.Info("Server starting on port " + port)
	s := newServer()
	log.Fatal(http.ListenAndServe(":"+port, s))
}
