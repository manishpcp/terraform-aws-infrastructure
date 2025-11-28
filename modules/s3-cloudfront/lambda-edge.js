'use strict';

/**
 * Lambda@Edge function for SEO-friendly headers
 * Triggered on origin-response
 */
exports.handler = (event, context, callback) => {
    const response = event.Records.cf.response;
    const headers = response.headers;

    // Security headers
    headers['x-frame-options'] = [{ key: 'X-Frame-Options', value: 'DENY' }];
    headers['x-content-type-options'] = [{ key: 'X-Content-Type-Options', value: 'nosniff' }];
    headers['x-xss-protection'] = [{ key: 'X-XSS-Protection', value: '1; mode=block' }];
    headers['referrer-policy'] = [{ key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' }];

    headers['content-security-policy'] = [{
        key: 'Content-Security-Policy',
        value: "default-src 'self'; script-src 'self' 'unsafe-inline';"
    }];

    headers['strict-transport-security'] = [{
        key: 'Strict-Transport-Security',
        value: 'max-age=31536000; includeSubDomains'
    }];

    callback(null, response);
};
