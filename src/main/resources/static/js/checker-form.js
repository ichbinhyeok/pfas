(function () {
	function updateSearchPanel(panel) {
		var search = panel.querySelector("[data-system-search='true']");
		var select = panel.querySelector("select[name='pwsid']");
		var status = panel.querySelector("[data-system-search-status]");
		if (!search || !select) {
			return;
		}

		var query = search.value.trim().toLowerCase();
		var placeholderOption = null;
		var visibleOptions = [];
		var totalOptions = 0;
		Array.prototype.forEach.call(select.options, function (option) {
			var isPlaceholder = option.dataset.systemPlaceholder === "true";
			if (isPlaceholder) {
				placeholderOption = option;
			}
			else {
				totalOptions += 1;
			}
			var haystack = (option.textContent + " " + option.value).toLowerCase();
			var isVisible = isPlaceholder
				? !query
				: !query || haystack.indexOf(query) !== -1;
			option.hidden = !isVisible;
			if (isVisible && !isPlaceholder) {
				visibleOptions.push(option);
			}
		});

		if (select.selectedOptions.length > 0 && select.selectedOptions[0].hidden) {
			if (visibleOptions.length > 0) {
				select.value = visibleOptions[0].value;
			}
			else if (placeholderOption) {
				select.value = placeholderOption.value;
			}
		}

		if (status) {
			status.textContent = query
				? visibleOptions.length + " utility option" + (visibleOptions.length === 1 ? "" : "s") + " shown"
				: totalOptions + " utility options available";
		}
	}

	function initPanel(panel) {
		if (!panel || panel.dataset.systemSearchReady === "true") {
			return;
		}
		panel.dataset.systemSearchReady = "true";
		var search = panel.querySelector("[data-system-search='true']");
		if (!search) {
			return;
		}
		search.addEventListener("input", function () {
			updateSearchPanel(panel);
		});
		updateSearchPanel(panel);
	}

	function initAll(root) {
		var scope = root || document;
		Array.prototype.forEach.call(scope.querySelectorAll("[data-system-search-panel='true']"), initPanel);
	}

	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", function () {
			initAll(document);
		});
	}
	else {
		initAll(document);
	}

	document.addEventListener("htmx:afterSwap", function (event) {
		initAll(event.target);
	});
})();
