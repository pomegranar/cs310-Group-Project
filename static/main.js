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
	resultAlert.classList.add(result.success ? "alert-success" : "alert-danger");
	resultAlert.textContent = result.message;
});

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


// For the QR code functionality.
const startScanButton = document.getElementById("start-scan");
const equipmentSelect = document.getElementById("equipment");

startScanButton.addEventListener("click", () => {
	const html5QrCode = new Html5Qrcode("qr-video");
	html5QrCode.start(
		{ facingMode: "environment" },
		{ fps: 10, qrbox: 250 },
		(qrCodeMessage) => {
			console.log("Scanned QR code:", qrCodeMessage);

			// Send scanned QR code to Flask to fetch equipment details
			fetch("/get_equipment_details", {
				method: "POST",
				headers: { "Content-Type": "application/json" },
				body: JSON.stringify({ equipment_id: qrCodeMessage }),
			})
				.then((response) => response.json())
				.then((data) => {
					if (data.status === "success") {
						// Populate the dropdown with the received equipment
						equipmentSelect.innerHTML = `
                            <option value="${data.equipment.equipment_id}">
                                ${data.equipment.name} (${data.equipment.sport})
                            </option>
                        `;
						alert("Equipment selected: " + data.equipment.name);
					} else {
						alert(data.message); // Handle errors
					}
				})
				.catch((err) => console.error(err));

			html5QrCode.stop();
		},
		(errorMessage) => {
			console.warn("QR code scanning failed:", errorMessage);
		}
	);
});
