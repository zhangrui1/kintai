<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdn.tailwindcss.com"></script>
<script src="/kintai/js/commonFunction.js"></script>
<style>
    table {
        width: 100%;
        table-layout: fixed; /* ✅ 列幅固定（項目ごとに設定が有効になる） */
        border-collapse: collapse;
    }

    th, td {
        border: 1px solid #ddd;
        padding: 4px 6px;
        text-align: center;
        white-space: nowrap;
        font-size: 0.9rem;
    }

    /* ✅ タイトル行：改行許可 */
    thead th {
        white-space: normal;
        line-height: 1.2;
        word-break: keep-all;
    }

    /* ✅ 各列の最小幅設定 */
    th:nth-child(1), td:nth-child(1) { min-width: 90px; }  /* 日付 */
    th:nth-child(2), td:nth-child(2) { min-width: 90px; }  /* 社員名 */
    th:nth-child(3), td:nth-child(3) { min-width: 120px; } /* 現場名 */
    th:nth-child(4), td:nth-child(4),
    th:nth-child(5), td:nth-child(5),
    th:nth-child(6), td:nth-child(6) { min-width: 70px; }  /* 移動系 */
    th:nth-child(7), td:nth-child(7) { min-width: 80px; }  /* 案件番号 */
    th:nth-child(8), td:nth-child(8) { min-width: 60px; }  /* 区分 */
    th:nth-child(9), td:nth-child(9),
    th:nth-child(10), td:nth-child(10),
    th:nth-child(11), td:nth-child(11),
    th:nth-child(12), td:nth-child(12) { min-width: 70px; } /* 時刻系 */
    th:nth-child(13), td:nth-child(13),
    th:nth-child(14), td:nth-child(14),
    th:nth-child(15), td:nth-child(15) { min-width: 65px; } /* 時間 */
    th:nth-child(16), td:nth-child(16) { min-width: 60px; }  /* 宿泊 */
    th:nth-child(17), td:nth-child(17) { min-width: 260px; } /* ✅ メモ欄拡張 */
    th:nth-child(18), td:nth-child(18) { min-width: 60px; }  /* 確認 */
    th:nth-child(19), td:nth-child(19) { min-width: 80px; }  /* 確認者 */
    th:nth-child(20), td:nth-child(20) { min-width: 120px; } /* 確認日時 */

    /* ✅ メモ欄の見やすさUP */
    td input.memoInput {
        width: 100%;
        min-height: 2rem;
        font-size: 0.9rem;
        text-align: left;
        padding: 3px 6px;
    }

    /* ✅ 改行・行間をやや詰める */
    .subrow {
        background: #fafafa;
        font-size: 0.85rem;
        line-height: 1.2;
    }

    /* 背景色はそのまま維持 */
    tr.in-progress { background-color: #fff7b0 !important; }
    tr.auto-complete { background-color: #e5e7eb !important; }
    tr.complete { background-color: #ffffff !important; }

</style>
<html lang="ja">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>月次作業一覧</title>

</head>

<body class="bg-gray-100 flex min-h-screen">
<!-- ✅ 左メニュー -->
<%--<iframe src="htmlframe/leftFrame.jsp" class="menu-frame"></iframe>--%>
<%--<c:import url="htmlframe/leftFrame.jsp"/>--%>
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
                    <th class="border px-3 py-1">社員名</th>
                    <th class="border px-3 py-1">現場名</th>
                    <th class="border px-3 py-1">本社→現場</th>
                    <th class="border px-3 py-1">現場→本社</th>
                    <th class="border px-3 py-1">現場→現場</th>
                    <th class="border px-3 py-1">案件番号</th>
                    <th class="border px-3 py-1">区分</th>
                    <th class="border px-3 py-1">実打刻出勤</th>
                    <th class="border px-3 py-1">実打刻退勤</th>
                    <th class="border px-3 py-1">勤怠出勤</th>
                    <th class="border px-3 py-1">勤怠退勤</th>
                    <th class="border px-3 py-1">移動時間</th>   <!-- ✅ 追加 -->
                    <th class="border px-3 py-1">作業時間</th>   <!-- ✅ 追加 -->
                    <th class="border px-3 py-1">合計</th>
                    <th class="border px-3 py-1">宿泊</th>
                    <th class="border px-3 py-1 w-48">社員用メモ</th>
                    <th class="border px-3 py-1">自己確定</th>
                    <th class="border px-3 py-1">上長確定</th>
                    <th class="border px-3 py-1">上長コメント</th>
                    <th class="border px-3 py-1">確定者</th>
                    <th class="border px-3 py-1">確定日時</th>
                </tr>
                </thead>
                <tbody id="monthList"></tbody>
            </table>
        </div>

<%--        <div class="text-right font-semibold mt-4">--%>
<%--            調整後合計作業時間: <span id="totalTime">0</span> 時間--%>
<%--        </div>--%>
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
    function roundHour(val) {
        return Math.round(val * 100) / 100; // 小数第2位まで正確に丸め
    }
    // ==== 表示 ====
    function renderMonthData(month, currentUserName) {
        const tbody = document.getElementById("monthList");
        tbody.innerHTML = "";

        // const allData = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");
        // ✅ monthlyRecords + attendanceRecords 統合データを使用
        const myData = loadPersonalMonthlyData(month, currentUserName);

//         // ✅ このユーザーのデータのみ取得
//         const myData = allData.filter(r =>
//             r.emp.replace(/\s/g, "") === currentUserName.replace(/\s/g, "") &&
//             r.date && r.date.startsWith(month)
//         );
//
        myData.sort((a, b) => a.date.localeCompare(b.date));
        let total = 0;
        myData.forEach(function(d, idx) {
            const adjStart = d.adjustedStart || (d.start ? roundTo15Up(d.start) : "");
            const adjEnd = d.adjustedEnd || (d.end ? roundTo15Down(d.end) : "");
            const info = getDayInfo(d.date);
            const dayName = info.dayName;
            const isSunday = info.isSunday;

            const tr = document.createElement("tr");
            tr.className = "text-center";
            // 🔸 状態別背景色（ここを追加）
            if (!d.end || d.end === "-") {
                tr.classList.add("in-progress");     // 打刻中：黄色
            } else if (d.type === "移動のみ") {
                tr.classList.add("auto-complete");   // 自動完結：灰色
            } else {
                tr.classList.add("complete");        // 完了済み：白
            }
            const dateCellClass = isSunday ? "sunday" : "";
// 🔸 移動のみの場合の特別表示
            const isMoveOnly = d.type === "移動のみ";
            const displayStart = isMoveOnly ? "-" : (d.start || "");
            const displayEnd = isMoveOnly ? "-" : (d.end || "");

            // ===== 各種時間の算出 =====
            const moveMin =
                (d.moveIn ? (d.moveInTime || 0) : 0) +
                (d.moveBetween ? (d.moveBetweenTime || 0) : 0) +
                (d.moveOut ? (d.moveOutTime || 0) : 0);

            var moveHrs = moveMin ? roundHour(moveMin / 60) : 0; // 移動時間（h）
            // 勤怠出勤・退勤ベースで作業時間算出
            var workHrs = 0;
            if (adjStart && adjEnd && !isMoveOnly) {
                let diff = timeToMin(adjEnd) - timeToMin(adjStart);
                if (diff < 0) diff += 1440;
                let hrs = diff / 60;
                if (hrs > 6) hrs -= 1;
                workHrs= roundHour(hrs);
            }
            var totalHrs = roundHour(workHrs + moveHrs);


            tr.innerHTML =
                "<td class='border px-3 py-1 " + dateCellClass + "'>" + d.date + "(" + dayName + ")</td>" +
                "<td class='border px-3 py-1'>" + d.emp + "</td>" +
                "<td class='border px-3 py-1'>" + (d.site || "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.moveIn ? "〇(" + (d.moveInTime || 0) + "分)" : "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.moveOut ? "〇(" + (d.moveOutTime || 0) + "分)" : "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.moveBetween ? "〇(" + (d.moveBetweenTime || 0) + "分)" : "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.proj || "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.type || "") + "</td>" +
                "<td class='border px-3 py-1'>" + displayStart + "</td>" +
                "<td class='border px-3 py-1'>" + displayEnd + "</td>" +
                "<td class='border px-3 py-1'><input type='time' class='border rounded px-1 text-center adjustedStart' value='" + adjStart + "'></td>" +
                "<td class='border px-3 py-1'><input type='time' class='border rounded px-1 text-center adjustedEnd' value='" + adjEnd + "'></td>" +
                "<td class='border px-3 py-1 durationCell'>" + moveHrs  + "</td>" +
                "<td class='border px-3 py-1 durationCell'>" + workHrs  + "</td>" +
                "<td class='border px-3 py-1 durationCell'>" + totalHrs  + "</td>" +
                "<td class='border px-3 py-1'>" + (d.stay || "-") + "</td>" +
                "<td class='border px-3 py-1'><input type='text' class='border rounded px-1 w-full memoInput' value='" + (d.memo || "") + "'></td>" +
                "<td class='border px-3 py-1 text-center'><input type='checkbox' class='selfConfirmCheck' " + (d.selfConfirmed ? "checked" : "") + "></td>" +
                "<td class='border px-3 py-1 text-center'>" + (d.managerConfirmed ? "✅" : "―") + "</td>" +
                "<td class='border px-3 py-1 text-left'>" + (d.managerComment || "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.confirmedBy || "") + "</td>" +
                "<td class='border px-3 py-1'>" + (d.confirmedAt || "") + "</td>";
            if (d.managerConfirmed) tr.classList.add("manager-confirmed");
            else if (d.selfConfirmed) tr.classList.add("self-confirmed");


// ✅ ここから下にイベントを追加する
            const memoInput = tr.querySelector(".memoInput");
            memoInput.addEventListener("change", () => {
                d.memo = memoInput.value;
                saveMonthlyEdit(d);
            });

// ✅ ⬇⬇⬇ ここに追加します
            const selfCheck = tr.querySelector(".selfConfirmCheck");
            selfCheck.addEventListener("change", () => {
                d.selfConfirmed = selfCheck.checked;
                console.log("selfCheck.checked=" + selfCheck.checked);
                saveMonthlyEdit(d);
            });

            tbody.appendChild(tr);
        });
        // 日別小計
        appendSubtotalRow(tbody, "合計", myData);
    }

    // ====== 個人用：月次データ読込（attendance と monthly を統合） ======
    function loadPersonalMonthlyData(month, empName) {
        const monthly = JSON.parse(localStorage.getItem("monthlyRecords") || "[]");
        const attendance = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");

        // --- attendance をキーで管理 ---
        const attendanceMap = {};
        attendance.forEach(r => {
            const key = r.emp + "_" + r.date + "_" + (r.proj || "");
            attendanceMap[key] = r;
        });

        // --- monthly 優先・欠落データを補完 ---
        const merged = monthly.map(m => {
            const key = m.emp + "_" + m.date + "_" + (m.proj || "");
            const base = attendanceMap[key] || {};
            return {
                date: m.date || base.date || "",
                emp: m.emp || base.emp || "",
                site: m.site || base.site || "",
                proj: m.proj || base.proj || "",
                type: m.type || base.type || "",
                start: m.start || base.start || "",
                end: m.end || base.end || "",
                adjustedStart: m.adjustedStart || base.adjustedStart || "",
                adjustedEnd: m.adjustedEnd || base.adjustedEnd || "",
                moveIn: m.moveIn ?? base.moveIn ?? false,
                moveInTime: m.moveInTime ?? base.moveInTime ?? 0,
                moveBetween: m.moveBetween ?? base.moveBetween ?? false,
                moveBetweenTime: m.moveBetweenTime ?? base.moveBetweenTime ?? 0,
                moveOut: m.moveOut ?? base.moveOut ?? false,
                moveOutTime: m.moveOutTime ?? base.moveOutTime ?? 0,
                stay: m.stay ?? base.stay ?? false,
                hotel: m.hotel ?? base.hotel ?? "",
                memo: m.memo ?? "",
                selfConfirmed:m.selfConfirmed??false,
                managerComment: m.managerComment ?? "",
                managerConfirmed: m.managerConfirmed ?? false,
                confirmedBy: m.confirmedBy ?? "",
                confirmedAt: m.confirmedAt ?? "",
                manager: m.manager || base.manager || ""
            };
        });

        // --- 該当ユーザー・月のみ返す ---
        return merged.filter(r =>
            r.emp.replace(/\s/g, "") === empName.replace(/\s/g, "") &&
            r.date && r.date.startsWith(month)
        );
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
