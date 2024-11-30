document.addEventListener("DOMContentLoaded", function() {
	const calendarBody = document.getElementById("calendarBody");
	const currentMonthYear = document.getElementById("currentMonthYear");
	const prevMonthButton = document.getElementById("prevMonth");
	const nextMonthButton = document.getElementById("nextMonth");

	let currentDate = new Date();

	// 이벤트 데이터를 가져오는 함수
	async function fetchEvents(year, month) {
		try {
			const response = await fetch(`getEvents.jsp?year=${year}&month=${month + 1}`);
			if (!response.ok) {
				throw new Error(`HTTP error! status: ${response.status}`);
			}
			return await response.json();
		} catch (error) {
			console.error("Error fetching events:", error);
			return [];
		}
	}

	// 캘린더 업데이트 함수
	async function updateCalendar(date) {
		const year = date.getFullYear();
		const month = date.getMonth();
		currentMonthYear.textContent = `${year}년 ${month + 1}월`;

		// 일정 데이터 가져오기
		const events = await fetchEvents(year, month);
		console.log("Fetched events:", events); // 디버깅용 로그

		calendarBody.innerHTML = "";

		const firstDayOfMonth = new Date(year, month, 1).getDay();
		const lastDateOfMonth = new Date(year, month + 1, 0).getDate();

		let row = document.createElement("tr");

		// 첫 번째 주 비어 있는 칸 채우기
		for (let i = 0; i < firstDayOfMonth; i++) {
			const emptyCell = document.createElement("td");
			row.appendChild(emptyCell);
		}

		// 날짜 채우기
		for (let day = 1; day <= lastDateOfMonth; day++) {
			const cell = document.createElement("td");
			const span = document.createElement("span");
			span.textContent = day; // 날짜 숫자
			cell.appendChild(span);

			// 오늘 날짜 표시
			const today = new Date();
			if (
				year === today.getFullYear() &&
				month === today.getMonth() &&
				day === today.getDate()
			) {
				cell.classList.add("today");
			}

			// 이벤트 데이터 확인
			const eventsOnDate = events.filter(e => e.date === `${year}-${month + 1}-${day}`);
			if (eventsOnDate.length > 0) {
				const eventContainer = document.createElement("div");
				eventContainer.classList.add("event-container");

				eventsOnDate.forEach(event => {
					const eventDiv = document.createElement("div");
					eventDiv.textContent = event.title; // 일정 제목 표시
					eventDiv.classList.add("event"); // 스타일 적용
					eventContainer.appendChild(eventDiv);
				});

				cell.appendChild(eventContainer);
			}

			// 팝업 연결
			cell.addEventListener("click", () => {
				const selectedDate = `${year}-${month + 1}-${day}`;
				document.getElementById("popupFrame").src = `calendar_popup.html?date=${selectedDate}`;
				document.getElementById("popupFrame").classList.remove("hidden");
			});

			row.appendChild(cell);

			// 한 주가 끝날 때 새로운 행 추가
			if ((firstDayOfMonth + day) % 7 === 0 || day === lastDateOfMonth) {
				calendarBody.appendChild(row);
				row = document.createElement("tr");
			}
		}

	}

	// 이전 달로 이동
	prevMonthButton.addEventListener("click", () => {
		currentDate.setMonth(currentDate.getMonth() - 1);
		updateCalendar(currentDate);
	});

	// 다음 달로 이동
	nextMonthButton.addEventListener("click", () => {
		currentDate.setMonth(currentDate.getMonth() + 1);
		updateCalendar(currentDate);
	});

	// 초기화 (오늘의 달을 표시)
	updateCalendar(currentDate);
});