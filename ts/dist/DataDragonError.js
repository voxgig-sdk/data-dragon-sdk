"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DataDragonError = void 0;
class DataDragonError extends Error {
    isDataDragonError = true;
    sdk = 'DataDragon';
    code;
    ctx;
    status = -1;
    // `err.notFound` rather than a magic number at every call site.
    get notFound() { return 404 === this.status; }
    constructor(code, msg, ctx) {
        super(msg);
        this.code = code;
        this.ctx = ctx;
    }
}
exports.DataDragonError = DataDragonError;
//# sourceMappingURL=DataDragonError.js.map