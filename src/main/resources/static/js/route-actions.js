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
			savedAt: new Date().toISOString(),
			detail: element.dataset.routeDetail || "",
			serviceLane: element.dataset.serviceLane || "",
			stateCode: element.dataset.stateCode || "",
			benchmarkRelation: element.dataset.benchmarkRelation || "",
			currentFilterStatus: element.dataset.currentFilterStatus || "",
			wholeHouseConsidered: element.dataset.wholeHouseConsidered || "",
			nextAction: element.dataset.nextAction || "",
			officialGuidanceUrl: element.dataset.officialGuidanceUrl || "",
			labLookupUrl: element.dataset.labLookupUrl || ""
		};
	}

	function composeRouteBrief(payload) {
		var lines = [];
		if (payload.detail) {
			lines.push(payload.detail);
		} else {
			if (payload.title) {
				lines.push(payload.title);
			}
			if (payload.summary) {
				lines.push(payload.summary);
			}
			if (lines.length > 0) {
				lines.push("");
			}
			if (payload.serviceLane) {
				lines.push("Service lane: " + payload.serviceLane);
			}
			if (payload.stateCode) {
				lines.push("State route: " + payload.stateCode);
			}
			if (payload.benchmarkRelation) {
				lines.push("Benchmark relation: " + payload.benchmarkRelation);
			}
			if (payload.currentFilterStatus) {
				lines.push("Current filter: " + payload.currentFilterStatus);
			}
			if (payload.wholeHouseConsidered) {
				lines.push("Whole-house considered: " + payload.wholeHouseConsidered);
			}
			if (payload.nextAction) {
				lines.push("Next action: " + payload.nextAction);
			}
			if (payload.officialGuidanceUrl) {
				lines.push("Official guidance: " + payload.officialGuidanceUrl);
			}
			if (payload.labLookupUrl) {
				lines.push("Certified lab lookup: " + payload.labLookupUrl);
			}
		}
		lines.push("Route: " + payload.url);
		return lines.join("\n");
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
		var body = composeRouteBrief(payload)
			+ "\nSaved from: " + window.location.href;
		window.location.href = "mailto:?subject=" + encodeURIComponent(subject) + "&body=" + encodeURIComponent(body);
		setStatus(button, "Mail draft opened with the current route summary.");
	}

	function copySummary(button) {
		var payload = routePayload(button);
		var text = composeRouteBrief(payload);
		if (navigator.clipboard && navigator.clipboard.writeText) {
			navigator.clipboard.writeText(text).then(function () {
				setStatus(button, "Copied the current route brief to the clipboard.");
			}).catch(function () {
				setStatus(button, "Clipboard copy failed in this browser. Use Download packet instead.");
			});
			return;
		}

		var fallback = document.createElement("textarea");
		fallback.value = text;
		fallback.setAttribute("readonly", "readonly");
		fallback.style.position = "absolute";
		fallback.style.left = "-9999px";
		document.body.appendChild(fallback);
		fallback.select();
		try {
			if (document.execCommand("copy")) {
				setStatus(button, "Copied the current route brief to the clipboard.");
			} else {
				setStatus(button, "Clipboard copy failed in this browser. Use Download packet instead.");
			}
		}
		catch (ignored) {
			setStatus(button, "Clipboard copy failed in this browser. Use Download packet instead.");
		}
		document.body.removeChild(fallback);
	}

	function downloadSummary(button) {
		var payload = routePayload(button);
		var text = composeRouteBrief(payload) + "\nSaved from: " + window.location.href + "\n";
		var blob = new Blob([text], { type: "text/plain;charset=utf-8" });
		var link = document.createElement("a");
		var slug = (payload.id || payload.title || "pfas-route")
			.toLowerCase()
			.replace(/[^a-z0-9]+/g, "-")
			.replace(/^-+|-+$/g, "");
		link.href = URL.createObjectURL(blob);
		link.download = (slug || "pfas-route") + ".txt";
		document.body.appendChild(link);
		link.click();
		document.body.removeChild(link);
		window.setTimeout(function () {
			URL.revokeObjectURL(link.href);
		}, 1000);
		setStatus(button, "Downloaded the current route packet as a text brief.");
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
			return;
		}

		var copyButton = event.target.closest("[data-route-copy='true']");
		if (copyButton) {
			event.preventDefault();
			copySummary(copyButton);
			return;
		}

		var downloadButton = event.target.closest("[data-route-download='true']");
		if (downloadButton) {
			event.preventDefault();
			downloadSummary(downloadButton);
		}
	}, true);
})();
