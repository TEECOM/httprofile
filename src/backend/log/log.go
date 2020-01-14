package log

import (
	"github.com/rs/xid"
	"github.com/sirupsen/logrus"
)

func SuccessfulProfile(url string) {
	logrus.WithField("url", url).Info("Completed profile successfully.")
}

func Info(message string) {
	logrus.Info(message)
}

func Error(err error) xid.ID {
	traceID := xid.New()
	logrus.WithField("traceID", traceID).Error(err)
	return traceID
}

func Fatal(err error) {
	logrus.Fatal(err)
}
