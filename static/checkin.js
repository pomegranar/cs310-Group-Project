document.addEventListener("DOMContentLoaded", function () {
	const sportContainer = document.querySelector("#sport-container");
	const equipmentSelect = document.getElementById("equipment");

	// Fetch sports dynamically
	function fetchAndRenderSports() {
		fetch("/get_sports")
			.then((response) => response.json())
			.then((sports) => {
				// Add "All" option
				let allRadio = document.createElement("input");
				allRadio.type = "radio";
				allRadio.className = "btn-check";
				allRadio.name = "options";
				allRadio.id = "option-all";
				allRadio.checked = true;
				let allLabel = document.createElement("label");
				allLabel.className = "btn btn-outline-primary";
				allLabel.htmlFor = "option-all";
				allLabel.textContent = "All";
				sportContainer.appendChild(allRadio);
				sportContainer.appendChild(allLabel);

				// Create buttons for each sport
				sports.forEach((sport, index) => {
					let sportRadio = document.createElement("input");
					sportRadio.type = "radio";
					sportRadio.className = "btn-check";
					sportRadio.name = "options";
					sportRadio.id = `option-${index}`;
					let sportLabel = document.createElement("label");
					sportLabel.className = "btn btn-outline-primary";
					sportLabel.htmlFor = `option-${index}`;
					sportLabel.textContent = sport.name;
					sportContainer.appendChild(sportRadio);
					sportContainer.appendChild(sportLabel);
				});

				addSportRadioListeners();
			})
			.catch((error) => console.error("Error fetching sports:", error));
	}

	// Fetch equipment for the selected sport
	function fetchAndUpdateEquipment(sport = "All") {
		equipmentSelect.innerHTML = "";

		fetch(`/get_borrowed_equipment?sport=${encodeURIComponent(sport)}`)
			.then((response) => response.json())
			.then((data) => {
				data.forEach((item) => {
					const option = document.createElement("option");
					option.value = item.equipment_id;
					option.textContent = `${item.sport} - ${item.name} #${item.number}`;
					equipmentSelect.appendChild(option);
				});
			})
			.catch((error) => console.error("Error fetching equipment:", error));
	}

	// Add listeners to sport radio buttons
	function addSportRadioListeners() {
		document.querySelectorAll('input[name="options"]').forEach((radio) => {
			radio.addEventListener("change", function () {
				const sport = this.nextElementSibling.textContent.trim();
				fetchAndUpdateEquipment(sport);
			});
		});
	}

	// Form submission
	document.getElementById("checkInForm").addEventListener("submit", function (event) {
		event.preventDefault();

		const card_id = document.getElementById("card_id").value;
		const equipment_id = document.getElementById("equipment").value;

		fetch("/checkin_equipment", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ card_id: card_id, equipment_id: equipment_id }),
		})
			.then((response) => response.json())
			.then((data) => {
				const result = document.getElementById("result");
				result.classList.remove("alert-success", "alert-danger", "d-none");
				result.classList.add(data.status === "success" ? "alert-success" : "alert-danger");
				result.textContent = data.message;

				// Refresh equipment
				const selectedSport = document.querySelector('input[name="options"]:checked').nextElementSibling.textContent.trim();
				fetchAndUpdateEquipment(selectedSport);
			})
			.catch((error) => {
				const result = document.getElementById("result");
				result.classList.remove("d-none");
				result.classList.add("alert-danger");
				result.textContent = "An error occurred. Please try again.";
				console.error("Error:", error);
			});
	});

	// Initialize sports and equipment
	fetchAndRenderSports();
	fetchAndUpdateEquipment();
});
