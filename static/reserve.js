// Reservation handling script for the database.
document.getElementById("reservationForm").addEventListener("submit", async (e) => {
	e.preventDefault();

	const response = await fetch("/reserve_facility", {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify({
			card_number: document.getElementById("cardNumber").value,
			facility_id: document.getElementById("facilityId").value,
			reserve_date: document.getElementById("reserveDate").value,
			start_time: document.getElementById("startTime").value,
			end_time: document.getElementById("endTime").value,
		}),
	});

	const result = await response.json();
	const resultAlert = document.getElementById("result");
	resultAlert.classList.remove("d-none");
	console.log(result.status);
	// Update the alert class based on the result status
	resultAlert.classList.remove("alert-success", "alert-danger", "d-none");
	resultAlert.classList.add(result.status === "success" ? "alert-success" : "alert-danger");
	resultAlert.classList.remove("d-none");
	resultAlert.textContent = result.message;
});

document.addEventListener("DOMContentLoaded", function () {
	const facilitySelect = document.getElementById("facilityId");

	// Fetch facility data from the server and populate options dynamically.
	fetch("/get_facility")
		.then((response) => response.json())
		.then((data) => {
			data.forEach((facility) => {
				const option = document.createElement("option");
				option.value = facility.facility_id;
				option.textContent = `Floor ${facility.floor}: ${facility.name} (Available: ${facility.reservable ? "Yes" : "No"})`;
				facilitySelect.appendChild(option);
			});
		})
		.catch((error) => console.error("Error fetching facility data:", error));
});
