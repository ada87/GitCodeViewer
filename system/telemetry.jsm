var EXPORTED_SYMBOLS = ['WorkspaceTelemetry'];

const { XPCOMUtils } = ChromeUtils.importESModule('resource://gre/modules/XPCOMUtils.sys.mjs');

XPCOMUtils.defineLazyModuleGetters(this, {
  AppConstants: 'resource://gre/modules/AppConstants.sys.mjs',
  Services: 'resource://gre/modules/Services.sys.mjs',
});

class WorkspaceTelemetry {
  constructor() {
    this._events = [];
  }

  recordOpen(workspaceId, filePath) {
    this._events.push({
      type: 'open',
      workspaceId,
      filePath,
      at: Date.now(),
    });
  }

  recordSync(workspaceId, status, changedFiles) {
    this._events.push({
      type: 'sync',
      workspaceId,
      status,
      changedFiles,
      at: Date.now(),
    });
  }

  recordSearch(query, resultCount) {
    this._events.push({
      type: 'search',
      query,
      resultCount,
      at: Date.now(),
    });
  }

  snapshot() {
    return this._events.map((event) => ({ ...event }));
  }

  summarize() {
    let opens = 0;
    let syncs = 0;
    let searches = 0;

    for (const event of this._events) {
      switch (event.type) {
        case 'open':
          opens += 1;
          break;
        case 'sync':
          syncs += 1;
          break;
        case 'search':
          searches += 1;
          break;
      }
    }

    return { opens, syncs, searches, platform: AppConstants.platform };
  }

  flushToConsole() {
    const summary = this.summarize();
    Services.console.logStringMessage(
      `[workspace-telemetry] opens=${summary.opens} syncs=${summary.syncs} searches=${summary.searches}`
    );
  }
}

const telemetry = new WorkspaceTelemetry();
telemetry.recordOpen('workspace-core', 'src/utils/string.ts');
telemetry.recordSearch('json5', 3);
telemetry.recordSync('syntax-lab', 'success', 14);