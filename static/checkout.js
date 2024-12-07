// Checkout handling script for the database:
document.addEventListener("DOMContentLoaded", function () {
	const sportContainer = document.querySelector("#sport-container"); // The div containing the radio buttons
	const equipmentSelect = document.getElementById("equipment");

	// Function to fetch and render sports
	function fetchAndRenderSports() {
		fetch("/get_sports")
			.then((response) => response.json())
			.then((sports) => {
				// Create the "All" option
				let allRadio = document.createElement("input");
				allRadio.type = "radio";
				allRadio.className = "btn-check";
				allRadio.name = "options";
				allRadio.id = "option-all";
				allRadio.checked = true;
				allRadio.setAttribute("autocomplete", "off");
				let allLabel = document.createElement("label");
				allLabel.className = "btn btn-outline-primary";
				allLabel.htmlFor = "option-all";
				allLabel.textContent = "All";
				sportContainer.appendChild(allRadio);
				sportContainer.appendChild(allLabel);

				// Add options for each sport
				sports.forEach((sport, index) => {
					let sportRadio = document.createElement("input");
					sportRadio.type = "radio";
					sportRadio.className = "btn-check";
					sportRadio.name = "options";
					sportRadio.id = `option-${index}`;
					sportRadio.setAttribute("autocomplete", "off");
					let sportLabel = document.createElement("label");
					sportLabel.className = "btn btn-outline-primary";
					sportLabel.htmlFor = `option-${index}`;
					sportLabel.textContent = sport.name;
					sportContainer.appendChild(sportRadio);
					sportContainer.appendChild(sportLabel);
				});

				// Add event listeners for dynamic dropdown updates
				addSportRadioListeners();
			})
			.catch((error) => console.error("Error fetching sports data:", error));
	}

	// Function to add event listeners to dynamically created radio buttons
	function addSportRadioListeners() {
		document.querySelectorAll('input[name="options"]').forEach((radio) => {
			radio.addEventListener("change", function () {
				const sport = this.nextElementSibling.textContent.trim(); // Get label text
				fetchAndUpdateEquipment(sport);
			});
		});
	}

	// Function to fetch and populate equipment data
	function fetchAndUpdateEquipment(sport = "All") {
		equipmentSelect.innerHTML = ""; // Clear existing options

		fetch(`/get_equipment?sport=${encodeURIComponent(sport)}`)
			.then((response) => response.json())
			.then((data) => {
				data.forEach((e) => {
					const option = document.createElement("option");
					option.value = e.equipment_id;
					option.textContent = `${e.sport} - ${e.name} #${e.number}`;
					equipmentSelect.appendChild(option);
				});
			})
			.catch((error) => console.error("Error fetching equipment data:", error));
	}

	// Initial fetch for sports and equipment
	fetchAndRenderSports();
	fetchAndUpdateEquipment();

	// Form submission for check-out
	document.getElementById("checkOutForm").addEventListener("submit", function (event) {
		event.preventDefault();

		const card_number = document.getElementById("card_id").value;
		const equipment_id = document.getElementById("equipment").value;

		fetch("/checkout_equipment", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ card_number: card_number, equipment_id: equipment_id }),
		})
			.then((response) => response.json())
			.then((data) => {
				const result = document.getElementById("result");
				result.classList.remove("alert-success", "alert-danger", "d-none");
				result.classList.add(data.status === "success" ? "alert-success" : "alert-danger");
				result.textContent = data.message;

				console.log(data);

				// Refresh the equipment list
				const selectedSport = document.querySelector('input[name="options"]:checked').nextElementSibling.textContent.trim();
				fetchAndUpdateEquipment(selectedSport);
			})
			.catch((error) => {
				const result = document.getElementById("result");
				result.classList.remove("d-none");
				result.classList.add("alert-danger");
				result.textContent = "An error occurred. Please try again.";
				console.error("Error submitting form:", error);
			});
	});
});
