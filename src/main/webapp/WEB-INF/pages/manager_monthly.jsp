<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ja">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>責任者用 月次作業一覧（宮本 義史 管理）</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="/kintai/js/commonFunction.js"></script>
    <style>
        .sunday { color: red; font-weight: bold; }
        .holiday { color: red; font-weight: bold; } /* 会社指定休日用：将来ここに適用 */
        table { table-layout: auto; width: 100%; }
        th, td { white-space: nowrap; }
        .subrow { background: #fafafa; }
        tr.in-progress { background-color: #fff7b0 !important; }   /* 進行中：黄色 */
        tr.auto-complete { background-color: #e5e7eb !important; } /* 自動完結：灰色 */
        tr.complete { background-color: #ffffff !important; }      /* 完了済：白 */
        /* ✅ 左メニューiframe */
        iframe.menu-frame {
            position: fixed;
            top: 0;
            left: 0;
            width: 60px;
            height: 100vh;
            border: none;
            transition: width 0.3s ease;
            z-index: 50;
        }
        iframe.menu-frame:hover {
            width: 240px;
        }

        main {
            margin-left: 60px;
            transition: margin-left 0.3s ease;
        }
        iframe.menu-frame:hover + main {
            margin-left: 240px;
        }
    </style>
</head>
<body class="bg-gray-100 flex min-h-screen">
<!-- ✅ 左メニュー -->
<%--<iframe src="htmlframe/leftFrame.jsp" class="menu-frame"></iframe>--%>
<%--<c:import url="htmlframe/leftFrame.jsp"/>--%>

<!-- ✅ メインコンテンツ -->
<main class="flex-1 p-6 bg-white overflow-x-auto ml-[60px] transition-all duration-300">
    <h1 class="text-xl font-bold mb-4 flex items-center justify-between">
        <span>月次作業一覧（責任者）  宮本 義史</span>
        <a href="/kintai/"
           class="bg-green-500 hover:bg-green-600 text-white text-sm px-3 py-1 rounded shadow">
            ◀ 打刻へ
        </a>
        　<a href="/kintai/personal_monthly"
            class="bg-blue-500 hover:bg-blue-600 text-white text-sm px-3 py-1 rounded shadow inline-block">
        ▶ 月次作業一覧へ（個人）
    </a>
    </h1>


    <!-- 操作パネル -->
    <div class="flex flex-wrap items-end gap-4 mb-4">
        <div>
            <label class="block text-xs font-semibold mb-1">表示月</label>
            <input type="month" id="monthSelect" class="border rounded px-2 py-1" value="2025-11"/>
        </div>

        <div>
            <label class="block text-xs font-semibold mb-1">社員フィルタ</label>
            <select id="employeeFilter" class="border rounded px-2 py-1 min-w-[12rem]">
                <option value="__ALL__">（全員）</option>
            </select>
        </div>

        <div>
            <label class="block text-xs font-semibold mb-1">表示モード</label>
            <div class="flex items-center gap-3">
                <label class="flex items-center gap-1 text-sm">
                    <input type="radio" name="viewMode" value="byDate"/> 日付順
                </label>
                <label class="flex items-center gap-1 text-sm">
                    <input type="radio" name="viewMode" value="byEmployee"/> 社員別で表示
                </label>
                　　　　　<label class="flex items-center gap-1 text-sm">
                <input type="radio" name="viewMode" value="btnByDate" checked/> 日付別で表示
            </label>
            </div>
        </div>

        <div class="ml-auto text-right">
            <div class="text-sm">責任者：<span id="managerNameView" class="font-semibold">宮本 義史</span></div>
            <div class="font-semibold">合計作業時間（休憩控除後）： <span id="totalTime">0.0</span> 時間</div>
        </div>
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
                <th class="border px-3 py-1 w-48">メモ</th>
                <th class="border px-3 py-1">確認</th>
                <th class="border px-3 py-1">確認者</th>
                <th class="border px-3 py-1">確認日時</th>
            </tr>
            </thead>
            <tbody id="listBody"></tbody>
        </table>
    </div>
</main>
<script>
    // ====== 固定：現在ログイン中の責任者（将来はログインから取得） ======
    const MANAGER_NAME = "宮本 義史";
    document.getElementById("managerNameView").textContent = MANAGER_NAME;

    // ====== Utility ======
    function roundTo15Up(time) {
        if (!time) return "";
        const [h, m] = time.split(":").map(Number);
        const total = h * 60 + m;
        const adj = Math.ceil(total / 15) * 15;
        const hh = String(Math.floor(adj / 60)).padStart(2, "0");
        const mm = String(adj % 60).padStart(2, "0");
        return hh + ":" + mm;
    }
    function roundTo15Down(time) {
        if (!time) return "";
        const [h, m] = time.split(":").map(Number);
        const total = h * 60 + m;
        const adj = Math.floor(total / 15) * 15;
        const hh = String(Math.floor(adj / 60)).padStart(2, "0");
        const mm = String(adj % 60).padStart(2, "0");
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

    // ====== データ読み込み（manager絞り込み＋月絞り込み） ======
    function loadManagerData(month, managerName) {
        const all = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");
        return all.filter(r => r.manager === managerName && r.date && r.date.startsWith(month));
    }

    // ====== 社員フィルタの候補作成 ======
    function buildEmployeeOptions(records) {
        const sel = document.getElementById("employeeFilter");
        const prev = sel.value;
        sel.innerHTML = `<option value="__ALL__">（全員）</option>`;
        const names = Array.from(new Set(records.map(r => r.emp))).sort((a,b)=>a.localeCompare(b,"ja"));
        names.forEach(n => {
            const opt = document.createElement("option");
            opt.value = n;
            opt.textContent = n;
            sel.appendChild(opt);
        });
        // 直前の選択を維持できるなら維持
        if ([...sel.options].some(o => o.value === prev)) sel.value = prev;
    }

    // ====== 表示本体 ======
    function render() {
        const month = document.getElementById("monthSelect").value;
        let records = loadManagerData(month, MANAGER_NAME);

        // 社員フィルタ候補
        buildEmployeeOptions(records);

        // フィルタ
        const empFilter = document.getElementById("employeeFilter").value;
        if (empFilter !== "__ALL__") {
            records = records.filter(r => r.emp === empFilter);
        }

        // ソート＆表示
        const viewMode = document.querySelector('input[name="viewMode"]:checked').value;
        const tbody = document.getElementById("listBody");
        tbody.innerHTML = "";

        // 作業時間計算用関数（調整→6h超は-1h）
        function calcAdjustedHours(rec) {
            const adjStart = rec.adjustedStart || (rec.start ? roundTo15Up(rec.start) : "");
            const adjEnd   = rec.adjustedEnd   || (rec.end   ? roundTo15Down(rec.end) : "");
            let min = 0;
            if (adjStart && adjEnd) {
                min = timeToMin(adjEnd) - timeToMin(adjStart);
                if (min < 0) min += 1440;
            }
            let hrs = min / 60;
            if (hrs > 6) hrs -= 1; // 6時間超は1時間休憩
            return { adjStart, adjEnd, hrs };
        }
        function roundHour(val) {
            return Math.round(val * 100) / 100; // 小数第2位まで正確に丸め
        }
        // 1行描画
        function appendRow(rec, subtotalCellRef = null) {
            const { dayName, isSunday } = getDayInfo(rec.date);
            const { adjStart, adjEnd, hrs } = calcAdjustedHours(rec);

            const tr = document.createElement("tr");
            tr.className = "text-center";
            // 🔸 状態別背景色（ここを追加）
            if (!rec.end || rec.end === "-") {
                tr.classList.add("in-progress");     // 打刻中：黄色
            } else if (rec.type === "移動のみ") {
                tr.classList.add("auto-complete");   // 自動完結：灰色
            } else {
                tr.classList.add("complete");        // 完了済み：白
            }

            const dateClass = isSunday ? "sunday" : "";

            // 🔸 移動のみの場合の特別表示
            const isMoveOnly = rec.type === "移動のみ";
            const displayStart = (rec.start || "");
            const displayEnd = isMoveOnly ? "-" : (rec.end || "");
            const displayDuration =  (hrs ? hrs.toFixed(1)  : "-");
            // ===== 各種時間の算出 =====
            const moveMin =
                (rec.moveIn ? (rec.moveInTime || 0) : 0) +
                (rec.moveBetween ? (rec.moveBetweenTime || 0) : 0) +
                (rec.moveOut ? (rec.moveOutTime || 0) : 0);

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
                "<td class='border px-3 py-1 " + dateClass + "'>" + rec.date + "(" + dayName + ")</td>" +
                "<td class='border px-3 py-1'>" + rec.emp + "</td>" +
                "<td class='border px-3 py-1'>" + (rec.site || "") + "</td>" +
                "<td class='border px-3 py-1'>" + (rec.moveIn ? "〇(" + (rec.moveInTime || 0) + "分)" : "") + "</td>" +
                "<td class='border px-3 py-1'>" + (rec.moveOut ? "〇(" + (rec.moveOutTime || 0) + "分)" : "") + "</td>" +
                "<td class='border px-3 py-1'>" + (rec.moveBetween ? "〇(" + (rec.moveBetweenTime || 0) + "分)" : "") + "</td>" +
                "<td class='border px-3 py-1'>" + (rec.proj || "") + "</td>" +
                "<td class='border px-3 py-1'>" + (rec.type || "") + "</td>" +
                "<td class='border px-3 py-1'>" + displayStart  + "</td>" +
                "<td class='border px-3 py-1'>" + displayEnd  + "</td>" +
                "<td class='border px-3 py-1'><input type='time' class='border rounded px-1 text-center adjustedStart' value='" + (adjStart || "") + "'></td>" +
                "<td class='border px-3 py-1'><input type='time' class='border rounded px-1 text-center adjustedEnd' value='" + (adjEnd || "") + "'></td>" +
                "<td class='border px-3 py-1 durationCell'>" + moveHrs  + "</td>" +
                "<td class='border px-3 py-1 durationCell'>" + workHrs  + "</td>" +
                "<td class='border px-3 py-1 durationCell'>" + totalHrs  + "</td>" +
                "<td class='border px-3 py-1'>" + (rec.stay || "-") + "</td>" +
                "<td class='border px-3 py-1'><input type='text' class='border rounded px-1 w-full memoInput' value='" + (rec.memo || "") + "'></td>" +
                "<td class='border px-3 py-1'><input type='checkbox' class='confirmCheck' " + (rec.confirmed ? "checked" : "") + "></td>" +
                "<td class='border px-3 py-1 confirmName'>" + (rec.confirmName || "") + "</td>" +
                "<td class='border px-3 py-1 confirmDate'>" + (rec.confirmDate || "") + "</td>";

            tbody.appendChild(tr);
        }


        // ===== 表示：日付順 =====
        if (viewMode === "byDate") {
            records.sort((a,b)=>{
                if (a.date !== b.date) return a.date.localeCompare(b.date);
                if (a.emp !== b.emp) return a.emp.localeCompare(b.emp, "ja");
                return (a.start||"").localeCompare(b.start||"");
            });
            records.forEach(r => appendRow(r));
        }

// ===== 表示：日付別（全員を日付ごとにグループ化） =====
        if (viewMode === "btnByDate") {
            // 🔹 日付ごとにグループ化
            const byDate = new Map();
            records.forEach(r => {
                if (!byDate.has(r.date)) byDate.set(r.date, []);
                byDate.get(r.date).push(r);
            });

            // 🔹 日付昇順に並び替え
            const sortedDates = [...byDate.keys()].sort(function(a, b) {
                return a.localeCompare(b);
            });

            sortedDates.forEach(function(date) {
                const list = byDate.get(date);
                const info = getDayInfo(date);
                const dayName = info.dayName;
                const isSunday = info.isSunday;

                // 小見出し行（各日付タイトル）
                const head = document.createElement("tr");
                head.className = "subrow";
                const dateClass = isSunday ? "sunday" : "";
                head.innerHTML =
                    "<td colspan='16' class='border px-3 py-1 font-semibold " + dateClass + "'>" +
                    "📅 " + date + "（" + dayName + "）の作業一覧" +
                    "</td>";
                tbody.appendChild(head);

                // 社員名順・開始時刻順で並び替え
                const sortedList = list.sort(function(a, b) {
                    if (a.emp !== b.emp) return a.emp.localeCompare(b.emp, "ja");
                    return (a.start || "").localeCompare(b.start || "");
                });

                // 各作業行を追加
                sortedList.forEach(function(r) {
                    appendRow(r);
                });

                // 日別小計
                appendSubtotalRow(tbody, date, sortedList);
            });
        }



        // ===== 表示：社員別 =====
        if (viewMode === "byEmployee") {
            const byEmp = new Map();
            records.forEach(r => {
                if (!byEmp.has(r.emp)) byEmp.set(r.emp, []);
                byEmp.get(r.emp).push(r);
            });
            const sortedEmp = [...byEmp.keys()].sort((a,b)=>a.localeCompare(b,"ja"));
            sortedEmp.forEach(emp => {
                // 小見出し行（社員別サマリ）
                const head = document.createElement("tr");
                head.className = "subrow";
                head.innerHTML =  "<td colspan='16' class='border px-3 py-1 text-left font-semibold'>👤 " + emp + "</td>";
                tbody.appendChild(head);

                const rows = byEmp.get(emp).sort((a,b)=>{
                    if (a.date !== b.date) return a.date.localeCompare(b.date);
                    return (a.start||"").localeCompare(b.start||"");
                });
                rows.forEach(r => appendRow(r));

                // 社員別の小計行
                appendSubtotalRow(tbody, emp, rows);
            });
        }

        // 合計更新
        updateTotals();

        function updateTotals() {
            const total = records.reduce((sum, rec)=>{
                const { hrs } = calcAdjustedHours(rec);
                return sum + (hrs || 0);
            }, 0);
            document.getElementById("totalTime").textContent = total.toFixed(1);
        }
    }

    function loadManagerMonthlyData(managerName, selectedEmp = "") {
        const all = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");

        // 責任者データのみ抽出
        const filtered = all.filter(r => r.manager === managerName);

        // 社員名でさらに絞り込み（全員の場合は無視）
        const viewData = selectedEmp ? filtered.filter(r => r.emp === selectedEmp) : filtered;

        // 表示更新
        renderMonthlyTable(viewData);
    }


    // ===== イベント =====
    document.getElementById("monthSelect").addEventListener("change", render);
    document.getElementById("employeeFilter").addEventListener("change", render);
    document.querySelectorAll('input[name="viewMode"]').forEach(r => r.addEventListener("change", render));

    // 初期表示
    document.addEventListener("DOMContentLoaded", render);
</script>
</body>
</html>
