document.addEventListener("DOMContentLoaded", function () {
	const equipmentContainer = document.getElementById("equipment-container");
	const checkInForm = document.getElementById("checkInForm");
	const result = document.getElementById("result");

	function fetchBorrowedEquipment(card_number) {
		// Clear current checkboxes
		equipmentContainer.innerHTML = "";

		fetch(`/get_borrowed_equipment?card_number=${card_number}`)
			.then((response) => response.json())
			.then((data) => {
				data.forEach((item) => {
					// Create a checkbox for each borrowed equipment
					const checkbox = document.createElement("input");
					checkbox.type = "checkbox";
					checkbox.className = "form-check-input";
					checkbox.id = `equipment-${item.equipment_id}`;
					checkbox.value = item.equipment_id;
					checkbox.checked = true; // Default to checked

					const label = document.createElement("label");
					label.className = "form-check-label";
					label.htmlFor = checkbox.id;
					label.textContent = `${item.name} #${item.number}`;

					const div = document.createElement("div");
					div.className = "form-check mb-2";
					div.appendChild(checkbox);
					div.appendChild(label);

					equipmentContainer.appendChild(div);
				});
			})
			.catch((error) => console.error("Error fetching borrowed equipment:", error));
	}

	// Handle form submission for check-in
	checkInForm.addEventListener("submit", function (event) {
		event.preventDefault();

		const card_number = document.getElementById("card_id").value;

		// Get all selected equipment IDs
		const selectedEquipment = Array.from(equipmentContainer.querySelectorAll("input[type=checkbox]:checked")).map((checkbox) => parseInt(checkbox.value));

		// Make API request to check in selected equipment
		fetch("/check_in_equipment", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ card_number, equipment_ids: selectedEquipment }),
		})
			.then((response) => response.json())
			.then((data) => {
				result.classList.remove("alert-success", "alert-danger", "d-none");
				result.classList.add(data.status === "success" ? "alert-success" : "alert-danger");
				result.textContent = data.message;

				if (data.status === "success") {
					fetchBorrowedEquipment(card_number); // Refresh equipment list
				}
			})
			.catch((error) => {
				result.classList.remove("d-none");
				result.classList.add("alert-danger");
				result.textContent = "An error occurred. Please try again.";
				console.error("Error submitting form:", error);
			});
	});

	// Fetch borrowed equipment when the page loads
	const cardInput = document.getElementById("card_id");
	cardInput.addEventListener("input", () => fetchBorrowedEquipment(cardInput.value));
});
