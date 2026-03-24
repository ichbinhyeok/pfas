(function () {
	function trackClick(anchor) {
		if (!anchor || anchor.dataset.routeClickTrack !== "true") {
			return;
		}

		var payload = JSON.stringify({
			clickId: anchor.dataset.routeClickId || "",
			sourcePage: anchor.dataset.routeClickSourcePage || window.location.pathname,
			targetPath: anchor.dataset.routeClickTargetPath || anchor.getAttribute("href") || "",
			ctaSlot: anchor.dataset.routeClickCtaSlot || "",
			routeFamily: anchor.dataset.routeClickFamily || "",
			laneLabel: anchor.dataset.routeClickLane || "",
			regionCode: anchor.dataset.routeClickRegion || ""
		});

		var url = "/route-clicks";
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
			// Static exports or simple hosts may not expose the tracking endpoint.
		});
	}

	document.addEventListener("click", function (event) {
		var anchor = event.target.closest("a[data-route-click-track='true']");
		if (!anchor) {
			return;
		}
		trackClick(anchor);
	}, true);
})();
