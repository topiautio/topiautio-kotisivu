document.querySelectorAll(".mobile-nav").forEach((menu) => {
    const summary = menu.querySelector("summary");

    menu.querySelectorAll("a").forEach((link) => {
        link.addEventListener("click", () => menu.removeAttribute("open"));
    });

    document.addEventListener("click", (event) => {
        if (menu.open && !menu.contains(event.target)) {
            menu.removeAttribute("open");
        }
    });

    document.addEventListener("keydown", (event) => {
        if (event.key === "Escape" && menu.open) {
            menu.removeAttribute("open");
            summary.focus();
        }
    });
});
