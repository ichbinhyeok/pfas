(function () {
	var STORAGE_KEY = "pfasSavedRoutes";
	var MAX_ROUTES = 20;

	function parseSavedRoutes() {
		try {
			var raw = window.localStorage.getItem(STORAGE_KEY);
			if (!raw) {
				return [];
			}
			var parsed = JSON.parse(raw);
			return Array.isArray(parsed) ? parsed : [];
		}
		catch (ignored) {
			return [];
		}
	}

	function writeSavedRoutes(routes) {
		try {
			window.localStorage.setItem(STORAGE_KEY, JSON.stringify(routes.slice(0, MAX_ROUTES)));
			return true;
		}
		catch (ignored) {
			return false;
		}
	}

	function routePayload(element) {
		return {
			id: element.dataset.routeId || "",
			title: element.dataset.routeTitle || document.title,
			summary: element.dataset.routeSummary || "",
			url: new URL(element.dataset.routeUrl || window.location.pathname, window.location.origin).toString(),
			savedAt: new Date().toISOString()
		};
	}

	function setStatus(element, message) {
		var container = element.closest("[data-route-actions]");
		if (!container) {
			return;
		}
		var status = container.querySelector("[data-route-status]");
		if (status) {
			status.textContent = message;
		}
	}

	function saveRoute(button) {
		var payload = routePayload(button);
		var savedRoutes = parseSavedRoutes().filter(function (route) {
			return route.id !== payload.id;
		});
		savedRoutes.unshift(payload);
		if (writeSavedRoutes(savedRoutes)) {
			button.textContent = "Saved on this device";
			button.disabled = true;
			setStatus(button, "Saved locally. This route can be recalled later on this device.");
			return;
		}
		setStatus(button, "Saving failed in this browser. Use Send summary instead.");
	}

	function sendSummary(button) {
		var payload = routePayload(button);
		var subject = "PFAS decision route: " + payload.title;
		var body = payload.summary
			+ "\n\nRoute: " + payload.url
			+ "\nSaved from: " + window.location.href;
		window.location.href = "mailto:?subject=" + encodeURIComponent(subject) + "&body=" + encodeURIComponent(body);
		setStatus(button, "Mail draft opened with the current route summary.");
	}

	document.addEventListener("click", function (event) {
		var saveButton = event.target.closest("[data-route-save='true']");
		if (saveButton) {
			event.preventDefault();
			saveRoute(saveButton);
			return;
		}

		var emailButton = event.target.closest("[data-route-email='true']");
		if (emailButton) {
			event.preventDefault();
			sendSummary(emailButton);
		}
	}, true);
})();
