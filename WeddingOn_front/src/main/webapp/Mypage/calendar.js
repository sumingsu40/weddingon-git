document.addEventListener("DOMContentLoaded", function () {
    const calendarBody = document.getElementById("calendarBody");
    const currentMonthYear = document.getElementById("currentMonthYear");
    const prevMonthButton = document.getElementById("prevMonth");
    const nextMonthButton = document.getElementById("nextMonth");
    const popupFrame = document.getElementById("popupFrame");

    let currentDate = new Date();

    function updateCalendar(date) {
        const year = date.getFullYear();
        const month = date.getMonth();
        currentMonthYear.textContent = `${year}년 ${month + 1}월`;

        calendarBody.innerHTML = "";

        const firstDayOfMonth = new Date(year, month, 1).getDay();
        const lastDateOfMonth = new Date(year, month + 1, 0).getDate();

        let row = document.createElement("tr");

        for (let i = 0; i < firstDayOfMonth; i++) {
            row.appendChild(document.createElement("td"));
        }

        for (let day = 1; day <= lastDateOfMonth; day++) {
            const cell = document.createElement("td");
            cell.textContent = day;

            cell.addEventListener("click", () => {
                popupFrame.src = `calendar_popup.html?date=${year}-${month + 1}-${day}`;
                popupFrame.classList.remove("hidden");
            });

            row.appendChild(cell);

            if ((firstDayOfMonth + day) % 7 === 0 || day === lastDateOfMonth) {
                calendarBody.appendChild(row);
                row = document.createElement("tr");
            }
        }
    }

    prevMonthButton.addEventListener("click", () => {
        currentDate.setMonth(currentDate.getMonth() - 1);
        updateCalendar(currentDate);
    });

    nextMonthButton.addEventListener("click", () => {
        currentDate.setMonth(currentDate.getMonth() + 1);
        updateCalendar(currentDate);
    });

    updateCalendar(currentDate);
});
