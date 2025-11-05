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
        /* ✅ テーブル全体をスクロール可能にする */
        .table-container {
            overflow: auto;
            max-height: 80vh;
            position: relative;
        }

        table {
            width: 100%;
            table-layout: fixed;
            border-collapse: collapse;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 4px 6px;
            text-align: center;
            white-space: nowrap;
            font-size: 0.9rem;
        }

        /* ✅ 見出し行（上部固定＋改行許可） */
        thead th {
            position: sticky;
            top: 0;
            background: #f3f4f6;
            z-index: 20;
            white-space: normal;
            line-height: 1.2;
            word-break: keep-all;
        }

        /* ✅ 左3列固定（日付・社員名・現場名） */
        th:nth-child(1),
        td:nth-child(1) {
            position: sticky;
            left: 0;
            z-index: 30;
            background: #fff;
        }

        th:nth-child(2),
        td:nth-child(2) {
            position: sticky;
            left: 90px; /* 1列目の幅に合わせる */
            z-index: 30;
            background: #fff;
        }

        th:nth-child(3),
        td:nth-child(3) {
            position: sticky;
            left: 180px; /* 1+2列分 */
            z-index: 30;
            background: #fff;
        }

        /* ✅ 固定列の罫線を上に描く（ヘッダー優先） */
        thead th:nth-child(1),
        thead th:nth-child(2),
        thead th:nth-child(3) {
            z-index: 40;
        }

        /* ✅ 各列の最小幅設定 */
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
        th:nth-child(17), td:nth-child(17) { min-width: 260px; } /* メモ欄 */
        th:nth-child(18), td:nth-child(18) { min-width: 60px; }  /* 確認 */
        th:nth-child(19), td:nth-child(19) { min-width: 80px; }  /* 確認者 */
        th:nth-child(20), td:nth-child(20) { min-width: 120px; } /* 確認日時 */

        /* ✅ メモ欄 */
        td input.memoInput {
            width: 100%;
            min-height: 2rem;
            font-size: 0.9rem;
            text-align: left;
            padding: 3px 6px;
        }

        /* ✅ 小計行 */
        .subrow {
            background: #fafafa;
            font-size: 0.85rem;
            line-height: 1.2;
        }

        /* === 状態別行背景（Tailwind上書き対応）=== */
        table tbody tr.in-progress > td,
        table tbody tr.in-progress > th {
            background-color: #fff7b0 !important;
        }
        table tbody tr.auto-complete > td,
        table tbody tr.auto-complete > th {
            background-color: #e5e7eb !important;
        }
        table tbody tr.complete > td,
        table tbody tr.complete > th {
            background-color: #ffffff !important;
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
    <div class="table-container">
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
            <tbody id="listBody"></tbody>
        </table>
    </div>
</main>
<script>
    // ====== 固定：現在ログイン中の責任者（将来はログインから取得） ======
    const MANAGER_NAME = "宮本 義史";
    document.getElementById("managerNameView").textContent = MANAGER_NAME;



    // ====== データ読み込み（manager絞り込み＋月絞り込み） ======
    function loadManagerData(month, managerName) {
        // 編集済み monthlyRecords を優先
        let monthly = JSON.parse(localStorage.getItem("monthlyRecords") || "[]");
        const attendance = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");

        // --- 初回：monthlyRecords がまだ存在しない場合は attendanceRecords から作成 ---
        if (!monthly || monthly.length === 0) {
            localStorage.setItem("monthlyRecords", JSON.stringify(attendance));
            monthly = attendance;
        }

        // --- monthly の中に欠落しているデータを attendanceRecords から補完する ---
        //     これにより start/end/moveIn/moveOut などを保持
        const attendanceMap = {};
        attendance.forEach(r => {
            const key = r.emp + "_" + r.date + "_" + (r.proj || "");
            attendanceMap[key] = r;
        });

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
                selfConfirmed:m.selfConfirmed??false, //自己確定
                managerComment: m.managerComment ?? "",       // ✅ 上長コメント追加
                managerConfirmed: m.managerConfirmed ?? false,// ✅ 上長確定フラグ追加
                confirmedBy: m.confirmedBy ?? "",             // ✅ 確定者
                confirmedAt: m.confirmedAt ?? "",             // ✅ 確定日時
                manager: m.manager || base.manager || ""
            };
        });

        // --- 月絞り込み ---
        const result = merged.filter(
            r => r.manager === managerName && r.date && r.date.startsWith(month)
        );

        return result;
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
    /********************************************
     * ✅ LocalStorage 同期・編集機能追加
     ********************************************/

// === attendanceRecords → monthlyRecords 同期 ===
    function syncAttendanceToMonthly() {
        const raw = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");
        const monthly = JSON.parse(localStorage.getItem("monthlyRecords") || "[]");

        // 既存データをキー化（emp+date+proj）
        const monthlyMap = {};
        monthly.forEach(r => {
            const key = r.emp + "_" + r.date + "_" + (r.proj || "");
            monthlyMap[key] = r;
        });

        const result = [];
        raw.forEach(r => {
            const key = r.emp + "_" + r.date + "_" + (r.proj || "");
            const moveMin =
                (r.moveIn ? (r.moveInTime || 0) : 0) +
                (r.moveBetween ? (r.moveBetweenTime || 0) : 0) +
                (r.moveOut ? (r.moveOutTime || 0) : 0);
            const moveHrs = moveMin / 60;

            let workHrs = 0;
            if (r.start && r.end && r.type !== "移動のみ") {
                let diff = timeToMin(r.end) - timeToMin(r.start);
                if (diff < 0) diff += 1440;
                workHrs = diff / 60;
                if (workHrs > 6) workHrs -= 1; // 休憩1h控除
            }

            const totalHrs = moveHrs + workHrs;
            const old = monthlyMap[key] || {};

            result.push({
                date: r.date,
                emp: r.emp,
                site: r.site,
                proj: r.proj,
                type: r.type,
                moveHrs: moveHrs,
                workHrs: workHrs,
                totalHrs: totalHrs,
                adjustedStart: old.adjustedStart || r.adjustedStart || r.start || "",
                adjustedEnd: old.adjustedEnd || r.adjustedEnd || r.end || "",
                memo: old.memo || "",
                selfConfirmed: old.selfConfirmed || false,
                managerComment: old.managerComment || "",
                managerConfirmed: old.managerConfirmed || false,
                confirmedBy: old.confirmedBy || "",   // ✅ confirmName → confirmedBy
                confirmedAt: old.confirmedAt || "",   // ✅ confirmDate → confirmedAt
                manager: r.manager || ""
            });
        });

        localStorage.setItem("monthlyRecords", JSON.stringify(result));
        console.log("✅ monthlyRecords synced:", result);
    }


    // === 編集結果を保存 ===
    function saveMonthlyEdit(rowData) {
        let monthly = JSON.parse(localStorage.getItem("monthlyRecords") || "[]");
        const key = rowData.emp + "_" + rowData.date + "_" + (rowData.proj || "");
        const idx = monthly.findIndex(
            r => (r.emp + "_" + r.date + "_" + (r.proj || "")) === key
        );
        const updated = {
            ...monthly[idx],
            adjustedStart: rowData.adjustedStart || "",
            adjustedEnd: rowData.adjustedEnd || "",
            memo: rowData.memo || "",
            managerComment: rowData.managerComment || "",
            managerConfirmed: rowData.managerConfirmed || false,
            confirmedBy: rowData.confirmedBy || "",
            confirmedAt: rowData.confirmedAt || "",
        };
        if (idx !== -1) {
            // 既存データとマージ（memo・確認情報を上書き）
            monthly[idx] = { ...monthly[idx], ...updated };
        } else {
            // 新規レコードとして追加
            monthly.push(rowData);
        }

        localStorage.setItem("monthlyRecords", JSON.stringify(monthly));
        console.log("💾 monthlyRecords updated:", updated);
        // alert("月次データを保存しました。");
    }


    // === テーブルに保存ボタンと入力フィールド追加 ===
    function addEditableFeatures() {
        const rows = document.querySelectorAll("#listBody tr");
        rows.forEach(tr => {
            // 既に加工済みの小計行はスキップ
            if (tr.classList.contains("subrow")) return;

            const emp = tr.children[1]?.textContent?.trim();
            const date = tr.children[0]?.textContent?.split("(")[0]?.trim();
            const proj = tr.children[6]?.textContent?.trim();

            // 勤怠出勤
            const startCell = tr.children[10];
            const endCell = tr.children[11];
            const memoCell = tr.children[16];
            const checkCell = tr.children[18];
            const momoManageCell=tr.children[19];
            const nameCell = tr.children[20];
            const dateCell = tr.children[21];


            if (!startCell || !endCell) return; // 小計行保護

            // 保存ボタン追加
            const saveBtn = document.createElement("button");
            saveBtn.textContent = "保存";
            saveBtn.className = "bg-blue-500 text-white text-xs px-2 py-1 rounded";
            const newTd = document.createElement("td");
            newTd.appendChild(saveBtn);
            tr.appendChild(newTd);

            saveBtn.onclick = function () {
                const adjustedStart = startCell.querySelector("input")?.value || "";
                const adjustedEnd = endCell.querySelector("input")?.value || "";
                const memo = memoCell.querySelector("input")?.value || "";
                const managerConfirmed  = momoManageCell.querySelector("input")?.value || "";
                // const confirmed = checkCell.querySelector("input")?.checked || false;
                const managerComment= checkCell.querySelector("input")?.checked || false;

                saveMonthlyEdit({
                    emp,
                    date,
                    proj,
                    adjustedStart,
                    adjustedEnd,
                    memo,
                    managerComment,
                    managerConfirmed,
                    confirmedBy: managerComment ? MANAGER_NAME : "",
                    confirmedAt: managerComment ? new Date().toLocaleString() : "",
                });

                // 表示更新
                nameCell.textContent = managerComment ? MANAGER_NAME : "";
                dateCell.textContent = managerComment ? new Date().toLocaleString() : "";
            };
        });
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
                "<td class='border px-3 py-1 text-center'>" + (rec.selfConfirmed ? "✅" : "―") + "</td>" +
                "<td class='border px-3 py-1 text-center'><input type='checkbox' class='managerConfirmCheck' " + (rec.managerConfirmed ? "checked" : "") + "></td>" +
                "<td class='border px-3 py-1 text-left'><input type='text' class='border rounded px-1 w-full managerCommentInput' value='" + (rec.managerComment || "") + "'></td>" +
                "<td class='border px-3 py-1 confirmedBy'>" + (rec.confirmedBy || "") + "</td>" +
                "<td class='border px-3 py-1 confirmedAt'>" + (rec.confirmedAt || "") + "</td>";

            tbody.appendChild(tr);

            // ✅ ここから下に追加してください
            const memoInput = tr.querySelector(".memoInput");
            memoInput.addEventListener("change", () => {
                rec.memo = memoInput.value;
                saveMonthlyEdit(rec);
            });

            const managerCommentInput = tr.querySelector(".managerCommentInput");
            managerCommentInput.addEventListener("change", () => {
                rec.managerComment  = managerCommentInput.value;
                saveMonthlyEdit(rec);
            });
            const mgrCheck = tr.querySelector(".managerConfirmCheck");
            const mgrComment = tr.querySelector(".managerCommentInput");

            mgrCheck.addEventListener("change", () => {
                rec.managerConfirmed = mgrCheck.checked;

                const nowStr = new Date().toLocaleString();
                const nameCell = tr.querySelector(".confirmedBy");
                const dateCell = tr.querySelector(".confirmedAt");

                if (mgrCheck.checked) {
                    rec.confirmedBy = MANAGER_NAME;
                    rec.confirmedAt = nowStr;
                    // ✅ 即時表示更新
                    nameCell.textContent = MANAGER_NAME;
                    dateCell.textContent = nowStr;
                } else {
                    rec.confirmedBy = "";
                    rec.confirmedAt = "";
                    nameCell.textContent = "";
                    dateCell.textContent = "";
                }

                saveMonthlyEdit(rec);
            });


            mgrComment.addEventListener("change", () => {
                rec.managerComment = mgrComment.value;
                saveMonthlyEdit(rec);
            });
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
    document.addEventListener("DOMContentLoaded", () => {
        syncAttendanceToMonthly();  // 打刻→月次 同期
        render();                   // 表示
        // addEditableFeatures();      // 編集機能付与
    });

</script>
</body>
</html>
