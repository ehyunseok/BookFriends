document.addEventListener("DOMContentLoaded", function() {
    // 테이블 행 클릭 시 이동 처리
    const rows = document.querySelectorAll("tr[data-url]");
    rows.forEach(row => {
        row.addEventListener("click", function() {
            const url = this.getAttribute("data-url");
            window.location.href = url;
        });
    });
});
