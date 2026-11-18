// Scalar configuration. Kept in its own file (not inline in index.html) so the
// page can be served with a Content-Security-Policy of script-src 'self'.
(function () {
  var isLocal = ['localhost', '127.0.0.1'].indexOf(window.location.hostname) !== -1

  Scalar.createApiReference('#app', {
    // OpenAPI schema, published next to this page (see scripts/build-docs.sh).
    url: 'MorphoSource-REST-API.yaml',

    // "Try it" requests go to the site serving these docs, so dev docs test
    // against the dev site and requests stay same-origin (no CORS needed).
    // Locally, fall back to the servers listed in the schema.
    servers: isLocal ? undefined : [{ url: window.location.origin, description: 'MorphoSource' }],

    // Pre-select the API key scheme so "Try it" shows the Authorization field.
    authentication: {
      preferredSecurityScheme: 'API-Key',
    },

    // Privacy and security: never store API keys in the browser, send no
    // telemetry, and turn off Scalar's hosted AI agent. Requests are never
    // routed through Scalar's proxy (no proxyUrl).
    persistAuth: false,
    telemetry: false,
    agent: { disabled: true },
    showDeveloperTools: 'never',

    // Use our own theme (below) and fonts instead of Scalar's defaults.
    // withDefaultFonts: false also avoids loading fonts from Scalar's servers.
    theme: 'none',
    withDefaultFonts: false,
    customCss: `
      .scalar-app, .scalar-api-reference {
        --scalar-custom-header-height: 56px;
        --scalar-font: "Helvetica Neue", Helvetica, Arial, sans-serif;
        --scalar-radius: 4px;
        --scalar-radius-lg: 6px;
        --scalar-radius-xl: 8px;
      }

      .light-mode {
        --scalar-background-1: #ffffff;
        --scalar-background-2: #f4f6f9;
        --scalar-background-3: #e6eaf0;
        --scalar-background-accent: #00388014;
        --scalar-color-1: #1f2933;
        --scalar-color-2: #4f5b67;
        --scalar-color-3: #7b8794;
        --scalar-color-accent: #003880;
        --scalar-link-color: #003880;
        --scalar-border-color: #dde2e9;

        --scalar-button-1: #003880;
        --scalar-button-1-hover: #002c64;
        --scalar-button-1-color: #ffffff;

        --scalar-sidebar-background-1: #f4f6f9;
        --scalar-sidebar-color-1: #1f2933;
        --scalar-sidebar-color-2: #4f5b67;
        --scalar-sidebar-color-active: #003880;
        --scalar-sidebar-item-hover-background: #00388010;
        --scalar-sidebar-item-hover-color: #003880;
        --scalar-sidebar-item-active-background: #0038801a;
        --scalar-sidebar-border-color: #dde2e9;
        --scalar-sidebar-search-background: #ffffff;
        --scalar-sidebar-search-border-color: #dde2e9;
        --scalar-sidebar-search-color: #4f5b67;
        --scalar-sidebar-indent-border-active: #f68628;
      }

      .dark-mode {
        --scalar-background-1: #0d1624;
        --scalar-background-2: #131f33;
        --scalar-background-3: #1b2a44;
        --scalar-background-accent: #7fb0ff1f;
        --scalar-color-1: #e8edf5;
        --scalar-color-2: #aab6c6;
        --scalar-color-3: #7f8da0;
        --scalar-color-accent: #7fb0ff;
        --scalar-link-color: #7fb0ff;
        --scalar-border-color: #263652;

        --scalar-button-1: #7fb0ff;
        --scalar-button-1-hover: #a3c7ff;
        --scalar-button-1-color: #0d1624;

        --scalar-sidebar-background-1: #0a121e;
        --scalar-sidebar-color-1: #e8edf5;
        --scalar-sidebar-color-2: #aab6c6;
        --scalar-sidebar-color-active: #7fb0ff;
        --scalar-sidebar-item-hover-background: #7fb0ff14;
        --scalar-sidebar-item-hover-color: #e8edf5;
        --scalar-sidebar-item-active-background: #7fb0ff22;
        --scalar-sidebar-border-color: #263652;
        --scalar-sidebar-search-background: #131f33;
        --scalar-sidebar-search-border-color: #263652;
        --scalar-sidebar-search-color: #aab6c6;
        --scalar-sidebar-indent-border-active: #f68628;
      }
    `,
  })
})()
