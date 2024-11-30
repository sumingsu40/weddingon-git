document.addEventListener("DOMContentLoaded", () => {
    console.log("My Writing page loaded successfully!");

    // 모든 댓글을 펼치거나 접는 기능 (필요하면 사용)
    const writings = document.querySelectorAll(".writing");

    writings.forEach((writing) => {
        writing.addEventListener("click", () => {
            const comments = writing.querySelector(".comments");
            if (comments) {
                // 댓글 토글 (펼치기/접기)
                if (comments.style.display === "none") {
                    comments.style.display = "block";
                } else {
                    comments.style.display = "none";
                }
            }
        });
    });
});
