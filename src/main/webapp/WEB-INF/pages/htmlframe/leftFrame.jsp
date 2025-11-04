<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header class="header">
<nav>
    <div class="menu-inner">
        <h2>管理者</h2>
        <a href="/kintai/manager_monthly" target="_top"><i data-feather="list"></i>月次作業一覧</a>
        <h2>従業員</h2>
        <a href="/kintai/personal_monthly" target="_top"><i data-feather="user"></i>個人月次一覧</a>
        <a href="/kintai/attendance_entry" target="_top"><i data-feather="edit-2"></i>打刻</a>
    </div>
</nav>
</header>
<script>
    // feather.replace();

    // === 現在URLから該当するメニューをハイライト ===
    const currentPath = window.location.pathname.split("/").pop(); // 現在ページ名
    const links = document.querySelectorAll("a");
    links.forEach(link => {
        const href = link.getAttribute("href");
        if (href && currentPath.endsWith(href)) {
            link.classList.add("active");
        }
    });

</script>
