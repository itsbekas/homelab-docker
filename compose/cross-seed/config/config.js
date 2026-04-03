"use strict";
module.exports = {
    apiKey: undefined,
    torznab: [
        "http://prowlarr:9696/4/api?apikey=PROWLARR_API_KEY",
        "http://prowlarr:9696/5/api?apikey=PROWLARR_API_KEY"
    ],
    sonarr: [
        "http://sonarr:8989/?apikey=SONARR_API_KEY",
    ],
    radarr: [
        "http://radarr:7878/?apikey=RADARR_API_KEY",
    ],
    host: "0.0.0.0",
    port: 2468,
    notificationWebhookUrls: [],
    torrentClients: [
        "qbittorrent:http://QBITTORRENT_USER:QBITTORRENT_PASSWORD@qbittorrent:6880",
    ],
    useClientTorrents: true,
    delay: 30,
    dataDirs: ["/data/downloads"],
    linkCategory: "cross-seed-link",
    linkDirs: [
        "/data/cross-seed/links"
    ],
    linkType: "hardlink",
    flatLinking: false,
    matchMode: "partial",
    skipRecheck: false,
    autoResumeMaxDownload: 52428800,
    ignoreNonRelevantFilesToResume: false,
    maxDataDepth: 3,
    torrentDir: null,
    outputDir: null,
    includeSingleEpisodes: false,
    includeNonVideos: false,
    seasonFromEpisodes: 1,
    fuzzySizeThreshold: 0.02,
    excludeOlder: "2 weeks",
    excludeRecentSearch: "3 days",
    action: "inject",
    duplicateCategories: true,
    rssCadence: "30 minutes",
    searchCadence: "1 day",
    snatchTimeout: "30 seconds",
    searchTimeout: "2 minutes",
    searchLimit: 400,
    blockList: [],
};
//# sourceMappingURL=config.template.cjs.map