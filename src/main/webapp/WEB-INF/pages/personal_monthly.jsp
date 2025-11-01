<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<html lang="ja">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>月次作業一覧</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .sunday { color: red; font-weight: bold; }
        .holiday { color: red; font-weight: bold; }
        table { table-layout: auto; width: 100%; }
        th, td { white-space: nowrap; }
    </style>
</head>

<body class="bg-gray-100 flex min-h-screen">
<!-- ✅ 左メニュー -->
<%--<iframe src="menu.html"--%>
<%--        class="fixed top-0 left-0 border-none w-[60px] h-screen hover:w-[240px] transition-all duration-300 z-50"></iframe>--%>

<!-- ✅ メインコンテンツ -->
<main class="flex-1 p-6 bg-white overflow-x-auto ml-[60px] transition-all duration-300">
    <div class="max-w-full mx-auto bg-white shadow rounded-2xl p-6 overflow-x-auto">
        <h1 class="text-xl font-bold mb-4 flex items-center justify-between">
            <span id="title_span">月次作業一覧</span>
            <div class="flex items-center gap-2">
                <a href="/kintai/"
                   class="bg-green-500 hover:bg-green-600 text-white text-sm px-3 py-1 rounded shadow">
                    ◀ 打刻へ
                </a>
                <a id="managerShow" href="/kintai/manager_monthly"
                   class="bg-blue-500 hover:bg-green-600 text-white text-sm px-3 py-1 rounded shadow inline-block">
                    ▶ 月次作業一覧へ（責任者）
                </a>
            </div>
        </h1>

        <!-- 月選択 -->
        <div class="flex justify-between items-center mb-4">
            <button id="prevMonth" class="text-blue-600 text-sm">◀ 前月</button>
            <div class="flex items-center space-x-2">
                <span class="font-semibold">表示月:</span>
                <input type="month" id="monthSelect" class="border rounded px-2 py-1" value="2025-11" />
            </div>
            <button id="nextMonth" class="text-blue-600 text-sm">翌月 ▶</button>
        </div>

        <!-- 一覧 -->
        <div class="overflow-x-auto">
            <table class="border text-sm table-auto">
                <thead class="bg-gray-200 text-center">
                <tr>
                    <th class="border px-3 py-1">日付(曜日)</th>
                    <th class="border px-3 py-1">現場名</th>
                    <th class="border px-3 py-1">本社→現場</th>
                    <th class="border px-3 py-1">現場→本社</th>
                    <th class="border px-3 py-1">案件番号</th>
                    <th class="border px-3 py-1">区分</th>
                    <th class="border px-3 py-1">実打刻出勤</th>
                    <th class="border px-3 py-1">実打刻退勤</th>
                    <th class="border px-3 py-1">勤怠出勤</th>
                    <th class="border px-3 py-1">勤怠退勤</th>
                    <th class="border px-3 py-1">実績時間</th>
                    <th class="border px-3 py-1">宿泊</th>
                    <th class="border px-3 py-1 w-48">メモ</th>
                    <th class="border px-3 py-1">確認</th>
                    <th class="border px-3 py-1">確認者</th>
                    <th class="border px-3 py-1">確認日時</th>
                </tr>
                </thead>
                <tbody id="monthList"></tbody>
            </table>
        </div>

        <div class="text-right font-semibold mt-4">
            調整後合計作業時間: <span id="totalTime">0</span> 時間
        </div>
    </div>
</main>

<!-- ======================= スクリプト ======================= -->
<script>
    // ==== Utility ====
    function roundTo15Up(time) {
        if (!time) return "";
        const [h, m] = time.split(":").map(Number);
        const total = h * 60 + m;
        const adjusted = Math.ceil(total / 15) * 15;
        const hh = String(Math.floor(adjusted / 60)).padStart(2, "0");
        const mm = String(adjusted % 60).padStart(2, "0");
        return hh + ":" + mm;
    }
    function roundTo15Down(time) {
        if (!time) return "";
        const [h, m] = time.split(":").map(Number);
        const total = h * 60 + m;
        const adjusted = Math.floor(total / 15) * 15;
        const hh = String(Math.floor(adjusted / 60)).padStart(2, "0");
        const mm = String(adjusted % 60).padStart(2, "0");
        return hh + ":" + mm;
    }
    function timeToMin(t) {
        if (!t) return 0;
        const [h, m] = t.split(":").map(Number);
        return h * 60 + m;
    }
    function getDayInfo(dateStr) {
        const d = new Date(dateStr);
        const days = ["日", "月", "火", "水", "木", "金", "土"];
        const dayName = days[d.getDay()];
        const isSunday = d.getDay() === 0;
        return { dayName, isSunday };
    }

    function pad2(n){ return n < 10 ? '0' + n : '' + n; }

    function formatDateTime(dt) {
        return dt.getFullYear() + '/' +
            pad2(dt.getMonth() + 1) + '/' +
            pad2(dt.getDate()) + ' ' +
            pad2(dt.getHours()) + ':' +
            pad2(dt.getMinutes());
    }

    // ==== 表示 ====
    function renderMonthData(month, currentUserName) {
        const tbody = document.getElementById("monthList");
        tbody.innerHTML = "";

        const allData = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");

        // ✅ このユーザーのデータのみ取得
        const myData = allData.filter(r =>
            r.emp.replace(/\s/g, "") === currentUserName.replace(/\s/g, "") &&
            r.date && r.date.startsWith(month)
        );

        myData.sort((a, b) => a.date.localeCompare(b.date));
        let total = 0;

        myData.forEach(function(d, idx) {
            const adjStart = d.adjustedStart || (d.start ? roundTo15Up(d.start) : "");
            const adjEnd = d.adjustedEnd || (d.end ? roundTo15Down(d.end) : "");
            const info = getDayInfo(d.date);
            const dayName = info.dayName;
            const isSunday = info.isSunday;

            let adjustedDurationMin = 0;
            if (adjStart && adjEnd) {
                adjustedDurationMin = timeToMin(adjEnd) - timeToMin(adjStart);
                if (adjustedDurationMin < 0) adjustedDurationMin += 1440;
            }

            let adjustedDurationHrs = adjustedDurationMin / 60;
            if (adjustedDurationHrs > 6) adjustedDurationHrs -= 1;
            total += adjustedDurationHrs;

            const tr = document.createElement("tr");
            tr.className = "text-center";
            const dateCellClass = isSunday ? "sunday" : "";

            tr.innerHTML =
                "<td class='border px-3 py-1 " + dateCellClass + "'>" + d.date + "(" + dayName + ")</td>" +
                "<td class='border px-3 py-1'>" + (d.site || "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.moveIn ? "〇(" + (d.moveInTime || 0) + "分)" : "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.moveOut ? "〇(" + (d.moveOutTime || 0) + "分)" : "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.proj || "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.type || "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.start || "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.end || "") + "</td>" +
                "<td class='border px-3 py-1'><input type='time' class='border rounded px-1 text-center adjustedStart' value='" + adjStart + "'></td>" +
                "<td class='border px-3 py-1'><input type='time' class='border rounded px-1 text-center adjustedEnd' value='" + adjEnd + "'></td>" +
                "<td class='border px-3 py-1 durationCell'>" + (adjustedDurationHrs ? adjustedDurationHrs.toFixed(1) + "時間" : "-") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.stay || "-") + "</td>" +
                "<td class='border px-3 py-1'><input type='text' class='border rounded px-1 w-full memoInput' value='" + (d.memo || "") + "'></td>" +
                "<td class='border px-3 py-1'><input type='checkbox' class='confirmCheck' " + (d.confirmed ? "checked" : "") + "></td>" +
                "<td class='border px-3 py-1 confirmName'>" + (d.confirmName || "") + "</td>" +
                "<td class='border px-3 py-1 confirmDate'>" + (d.confirmDate || "") + "</td>";

            tbody.appendChild(tr);
        });


        document.getElementById("totalTime").textContent = total.toFixed(1);
    }

    // ==== 月切替 ====
    document.addEventListener("DOMContentLoaded", () => {
        const monthInput = document.getElementById("monthSelect");

        const currentUserName = localStorage.getItem("userName") || "宮本 義史";
        const userRole = localStorage.getItem("userRole") || "manager";

        // タイトル反映
        document.getElementById("title_span").textContent = "月次作業一覧"+currentUserName;

        // 責任者リンク表示制御
        const managerShow = document.getElementById("managerShow");
        if (userRole === "staff") {
            managerShow.style.display = "none";
        } else {
            managerShow.style.display = "inline-block";
        }

        // 初期表示
        renderMonthData(monthInput.value, currentUserName);

        // 月切替
        monthInput.addEventListener("change", () => renderMonthData(monthInput.value, currentUserName));
        document.getElementById("prevMonth").addEventListener("click", () => {
            const [y, m] = monthInput.value.split("-").map(Number);
            const prev = new Date(y, m - 2);
            monthInput.value = prev.toISOString().slice(0, 7);
            renderMonthData(monthInput.value, currentUserName);
        });
        document.getElementById("nextMonth").addEventListener("click", () => {
            const [y, m] = monthInput.value.split("-").map(Number);
            const next = new Date(y, m);
            monthInput.value = next.toISOString().slice(0, 7);
            renderMonthData(monthInput.value, currentUserName);
        });
    });
</script>
</body>
</html>
