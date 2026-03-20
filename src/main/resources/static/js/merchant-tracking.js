(function () {
	function trackClick(anchor) {
		if (!anchor || anchor.dataset.merchantTrack !== "true") {
			return;
		}

		var payload = JSON.stringify({
			productId: anchor.dataset.productId || "",
			merchant: anchor.dataset.merchant || "",
			ctaSlot: anchor.dataset.ctaSlot || "",
			sourcePage: anchor.dataset.sourcePage || "",
			routeType: anchor.dataset.routeType || "",
			targetUrl: anchor.href || anchor.dataset.targetUrl || "",
			pagePath: window.location.pathname
		});

		var url = "/internal/merchant-clicks";
		if (navigator.sendBeacon) {
			try {
				navigator.sendBeacon(url, new Blob([payload], { type: "application/json" }));
				return;
			}
			catch (ignored) {
				// Fall through to fetch.
			}
		}

		fetch(url, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: payload,
			keepalive: true
		}).catch(function () {
			// Static exports or simple hosts may not expose the internal endpoint.
		});
	}

	document.addEventListener("click", function (event) {
		var anchor = event.target.closest("a[data-merchant-track='true']");
		if (!anchor) {
			return;
		}
		trackClick(anchor);
	}, true);
})();
