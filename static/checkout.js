// Checkout handling script for the database.
document.addEventListener("DOMContentLoaded", function () {
	const equipmentSelect = document.getElementById("equipment");

	// Fetch equipment data from the server and populate options dynamically.
	fetch("/get_equipment")
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
				result.classList.remove("d-none");
				result.classList.add(data.success ? "alert-success" : "alert-danger");
				result.textContent = data.message;
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
