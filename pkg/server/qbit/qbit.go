package qbit

import (
	"github.com/rs/zerolog"
	"github.com/latisen/cloudarr_v2/internal/config"
	"github.com/latisen/cloudarr_v2/internal/logger"
	"github.com/latisen/cloudarr_v2/pkg/manager"
)

type QBit struct {
	downloadFolder          string
	categories              []string
	alwaysRemoveTrackerURLS bool
	logger                  zerolog.Logger
	Tags                    []string
	manager                 *manager.Manager
}

func New(manager *manager.Manager) *QBit {
	cfg := config.Get()
	return &QBit{
		downloadFolder:          cfg.DownloadFolder,
		categories:              cfg.Categories,
		alwaysRemoveTrackerURLS: cfg.AlwaysRmTrackerUrls,
		manager:                 manager,
		logger:                  logger.New("qbit"),
	}
}
