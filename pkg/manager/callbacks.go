package manager

import (
	"github.com/latisen/cloudarr_v2/pkg/storage"
)

func (m *Manager) RemoveFromProvider(providerEntry *storage.ProviderEntry) error {
	if providerEntry == nil {
		return nil
	}
	if providerEntry.Provider == "usenet" {
		if m.usenet != nil {
			return m.usenet.Delete(providerEntry.ID)
		}
		return nil
	}

	client := m.ProviderClient(providerEntry.Provider)
	if client == nil {
		return nil
	}
	return client.DeleteTorrent(providerEntry.ID)
}

func (m *Manager) RemoveTorrentPlacements(t *storage.Entry) {
	for _, placement := range t.Providers {
		if err := m.RemoveFromProvider(placement); err != nil {
			m.logger.Warn().Err(err).
				Str("provider", placement.Provider).
				Str("id", placement.ID).
				Str("info_hash", t.InfoHash).
				Msg("Failed to remove stalled torrent from provider")
		}
	}
}
