<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<html lang="ja">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>現場作業入力</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="/kintai/js/commonFunction.js"></script>
    <style>
        /* ℹ️ 共通ツールチップ修正版 */
        .tooltip {
            position: absolute;
            background-color: #1f2937;
            color: white;
            font-size: 0.75rem;
            border-radius: 0.25rem;
            padding: 0.25rem 0.5rem;
            opacity: 0;
            pointer-events: none;
            white-space: nowrap;
            transition: opacity 0.2s ease;
            z-index: 10;
        }
        .group:hover .tooltip {
            opacity: 1;
            pointer-events: auto;
        }
        tr.in-progress { background-color: #fff7b0; }   /* 黄色：進行中 */
        tr.auto-complete { background-color: #e5e7eb; } /* 灰色：自動完結 */
        tr.complete { background-color: #ffffff; }      /* 白：完了済み */
    </style>
</head>

<body class="bg-gray-100 flex min-h-screen">
<!-- ✅ 左メニュー -->
<%--<iframe src="menu.html"--%>
<%--        class="fixed top-0 left-0 border-none w-[60px] h-screen hover:w-[240px] transition-all duration-300 z-50"></iframe>--%>

<!-- ✅ メイン -->
<main class="flex-1 p-6 bg-white overflow-x-auto ml-[60px] transition-all duration-300">
    <div class="max-w-6xl mx-auto bg-white rounded-2xl shadow p-6">

        <h1 class="text-xl font-bold mb-4 flex items-center justify-between">
            <span id="pageTitle">(責任者)打刻</span>
            <div class="flex items-center gap-2">
                <button id="roleSwitchBtn" class="bg-gray-200 hover:bg-gray-300 text-sm px-3 py-1 rounded shadow">
                    切替：作業者
                </button>
                <a href="/kintai/personal_monthly" id="personalLink"
                   class="bg-blue-500 hover:bg-blue-600 text-white text-sm px-3 py-1 rounded shadow">
                    ▶ 月次作業一覧へ
                </a>
                <a id="managerShow" href="/kintai/manager_monthly"
                   class="bg-green-500 hover:bg-green-600 text-white text-sm px-3 py-1 rounded shadow">
                    ▶ 月次作業一覧へ（責任者）
                </a>
            </div>
        </h1>

        <!-- ✅ あなたのフォームそのまま -->
        <form id="attendanceForm" class="space-y-4">
            <!-- チーム管理 -->
            <div class="flex items-center space-x-2" id="teamTeamdiv">
                <select id="teamSelect" class="border rounded px-3 py-2 flex-1">
                    <option value="">-- チームを選択 --</option>
                </select>
                <button type="button" id="btnSaveTeam" class="text-blue-600 text-sm">＋ チーム登録</button>
                <button type="button" id="btnDeleteTeam" class="text-red-600 text-sm">－ 削除</button>
                <!-- ℹ️ 情報アイコン -->
                <div class="relative group" >
                    <span class="text-gray-500 text-xs cursor-pointer select-none">ℹ️</span>
                    <div class="tooltip -top-8 left-0">
                        チーム登録：選択中の社員を新しいチームとして保存します。<br>
                        削除：選択中のチームを削除します。
                    </div>
                </div>
            </div>

            <!-- 日付 -->
            <div>
                <label class="block text-sm font-semibold mb-1 flex items-center space-x-1">
                    <span>日付</span>
                    <div class="relative group">
                        <span class="text-gray-500 text-xs cursor-pointer select-none">ℹ️</span>
                        <div class="tooltip -top-8 left-0">当日のみ</div>
                    </div>
                </label>
                <input type="date" id="workDate" class="w-full border rounded px-3 py-2" />
            </div>

            <!-- 社員選択 -->
            <div>
                <label class="block text-sm font-semibold mb-1 flex items-center space-x-1">
                    <span>社員を選択</span>
                    <div class="relative group">
                        <span class="text-gray-500 text-xs cursor-pointer select-none">ℹ️</span>
                        <div class="tooltip -top-12 left-0">
                            チーム社員を選択して「開始」や「終了」を押すと一括入力できます。<br>
                            社員選択後に「チーム登録」でパターン保存できます。
                        </div>
                    </div>
                </label>
                <div class="border rounded p-2 space-y-2">
                    <div id="selectedEmployees" class="flex flex-wrap gap-2 min-h-[2rem]"></div>
                    <input type="text" id="employeeSearch" placeholder="社員名を入力..." class="w-full border rounded px-2 py-1" />
                    <div id="employeeDropdown" class="border rounded bg-white shadow mt-1 hidden max-h-40 overflow-y-auto"></div>
                </div>
            </div>

            <!-- 現場・案件 -->
            <div class="grid md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-semibold mb-1 flex items-center space-x-1">
                        <span>現場名</span>
                        <div class="relative group">
                            <span class="text-gray-500 text-xs cursor-pointer select-none">ℹ️</span>
                            <div class="tooltip -top-8 left-0">案件システムから取得する現場名です。</div>
                        </div>
                    </label>
                    <select id="siteSelect" class="w-full border rounded px-3 py-2">
                        <option>本社</option>
                        <option>東京A現場</option>
                        <option>大阪B現場</option>
                        <option>名古屋C現場</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-semibold mb-1 flex items-center space-x-1">
                        <span>案件番号</span>
                        <div class="relative group">
                            <span class="text-gray-500 text-xs cursor-pointer select-none">ℹ️</span>
                            <div class="tooltip -top-8 left-0">案件システムから取得する案件番号です。</div>
                        </div>
                    </label>
                    <select id="projectSelect" class="w-full border rounded px-3 py-2">
                        <option></option>
                        <option>TX000125</option>
                        <option>TX000126</option>
                        <option>TX000127</option>
                    </select>
                </div>
            </div>

            <!-- 移動区分 -->
            <div id="moveTypeSection" class="mt-2">
                <label class="block text-sm font-semibold mb-1">移動区分（複数選択可）</label>
                <div class="flex flex-col md:flex-row md:space-x-4 space-y-2 md:space-y-0">
                    <label><input type="checkbox" name="moveType" value="hq_to_site"> 本社から現場へ</label>
                    <label><input type="checkbox" name="moveType" value="site_to_hq"> 現場から本社へ</label>
                    <label><input type="checkbox" name="moveType" value="site_to_site"> 現場間移動</label>
                </div>
            </div>

            <!-- 作業有無 -->
            <div class="mt-2">
                <label class="block text-sm font-semibold mb-1">作業有無</label>
                <div class="flex space-x-4">
                    <label><input type="radio" name="hasWork" value="yes" checked> 作業あり</label>
                    <label><input type="radio" name="hasWork" value="no"> 作業なし（移動・宿泊のみ）</label>
                </div>
            </div>

            <!-- 宿泊 -->
            <div class="mt-2">
                <label class="block text-sm font-semibold mb-1">宿泊</label>
                <div class="flex items-center space-x-3">
                    <label><input type="checkbox" id="stayCheck"> 宿泊あり</label>
                    <input type="text" id="hotelName" placeholder="ホテル名を入力" class="flex-1 border rounded px-3 py-2" disabled />
                </div>
            </div>

            <!-- 操作ボタン -->
            <div class="flex flex-wrap gap-3 justify-end">
                <button type="button" id="btnStart" class="bg-green-600 text-white px-4 py-2 rounded">開始</button>
                <button type="button" id="btnEnd" class="bg-red-600 text-white px-4 py-2 rounded">終了</button>
            </div>
        </form>

        <hr class="my-6" />
        <!-- 登録一覧 -->
        <h2 class="text-lg font-semibold mb-2">本日の登録一覧</h2>
        <table class="w-full border text-sm">
            <thead class="bg-gray-200">
            <tr>
                <th class="border px-2 py-1">順序</th>
                <th class="border px-2 py-1">日付</th>
                <th class="border px-2 py-1">社員名</th>
                <th class="border px-2 py-1">現場名</th>
                <th class="border px-2 py-1">案件番号</th>
                <th class="border px-2 py-1">区分</th>
                <th class="border px-2 py-1">開始時間</th>
                <th class="border px-2 py-1">終了時間</th>
                <th class="border px-2 py-1">作業時間</th>
                <th class="border px-2 py-1">宿泊ホテル</th>
                <th class="border px-2 py-1">操作</th>
            </tr>
            </thead>
            <tbody id="entryList"></tbody>
        </table>
    </div>
</main>

<script>
    /* --- 社員リストと基本変数 --- */
    const allEmployees = ["宮本 義史","岡本 敦也","切原 繁","川本 浩史","井上 直紀",
        "平山 裕樹","宇都宮 朗","喜馬 大佑","髙岩 沢也","雅"];
    const list = document.getElementById("entryList");
    let activeEmployees = JSON.parse(localStorage.getItem("activeEmployees")||"{}");
    const DEFAULT_MOVE_TIME = 45; // デフォルト移動時間（分）
    const managerName = "宮本 義史";
    /* --- 初期表示 --- */
    window.addEventListener("DOMContentLoaded",()=>{
        loadTeams();
        applyRole();

        const today=new Date();
        const yyyy=today.getFullYear(),mm=String(today.getMonth()+1).padStart(2,"0"),dd=String(today.getDate()).padStart(2,"0");
        const todayStr = yyyy + "-" + mm + "-" + dd;
        // === すべての当日レコードを読み込み ===
        const all=JSON.parse(localStorage.getItem("attendanceRecords")||"[]");
        const activeEmployees = JSON.parse(localStorage.getItem("activeEmployees") || "{}");
        // ✅ 今日の全レコード（この責任者の管理分）
        const todaysRecords = all.filter(r =>
            r.date === todayStr && r.manager === managerName // ←責任者の名前
        );
        // === 1. 今日の記録をすべて表示 ===
        todaysRecords.forEach(r => {
            const inProgress = (!r.end || r.end === "-");
            addRowNew(r, inProgress);
        });
        // === activeEmployees に残っている進行中データを補完表示 ===
        for (const emp in activeEmployees) {
            const a = activeEmployees[emp];

            // 既に上で表示済みならスキップ
            const alreadyShown = todaysRecords.some(r =>
                r.emp === emp &&
                r.date === todayStr &&
                (!r.end || r.end === "-")
            );
            if (alreadyShown) continue;
            const rec = {
                date: todayStr,
                emp: emp,
                site: a.site || "",
                proj: a.proj || "",
                start: a.start || "-",
                end: "-",
                duration: 0,
                stay: a.stay || false,
                hotel: a.hotel || "",
                type: "作業",
                moveIn: a.moveIn || false,
                moveInTime: a.moveInTime || 0,
                moveBetween: a.moveBetween || false,
                moveBetweenTime: a.moveBetweenTime || 0,
                moveOut: a.moveOut || false,
                moveOutTime: a.moveOutTime || 0
            };
            addRowNew(rec, true); // ✅ 第二引数 true → 黄色背景付与
        }
    });

    // ====== 時間ユーティリティ ======
    function getCurrentTime() { const n = new Date(); return { h: n.getHours(), m: n.getMinutes() }; }
    function formatTime(h, m) {
        return String(h).padStart(2, "0") + ":" + String(m).padStart(2, "0");
    }

    function timeToMinutes(t) { const [h, m] = t.split(":").map(Number); return h * 60 + m; }
    function calcDuration(s, e) { let d = timeToMinutes(e) - timeToMinutes(s); if (d < 0) d += 1440; return d; }
    function addMinutes(h, m, min) { let t = h * 60 + m + min; if (t >= 1440) t -= 1440; return { h: Math.floor(t / 60), m: t % 60 }; }
    function subtractMinutes(h, m, min) { let t = h * 60 + m - min; if (t < 0) t += 1440; return { h: Math.floor(t / 60), m: t % 60 }; }
    function getStandardTravelTime(t) {
        if (["hq_to_site", "site_to_hq"].includes(t)) return DEFAULT_MOVE_TIME;
        if (t === "site_to_site") return DEFAULT_MOVE_TIME;
        return 0;
    }
    /* --- 日付自動設定 --- */
    function todayStr() {
        const d = new Date();
        var temp = d.getFullYear() + "-" +
            String(d.getMonth() + 1).padStart(2, "0") + "-" +
            String(d.getDate()).padStart(2, "0");
        console.log("今日の日付＝ " + temp);
        return temp;
    }

    // ====== 表制御 ======
    let seq = 1;
    function sortEntryList() {
        const rows = Array.from(list.querySelectorAll("tr"));
        rows.sort((a, b) => {
            const empA = a.children[2].textContent.trim(), empB = b.children[2].textContent.trim();
            if (empA !== empB) return empA.localeCompare(empB, "ja");
            const startA = a.querySelector(".start-time").textContent || "99:99";
            const startB = b.querySelector(".start-time").textContent || "99:99";
            return startA.localeCompare(startB);
        });
        rows.forEach((r, i) => { r.children[0].textContent = i + 1; list.appendChild(r); });
    }
    document.getElementById("workDate").value=todayStr();



    /* --- 社員検索ボックス --- */
    // ====== 社員選択 ======
    const selectedDiv = document.getElementById("selectedEmployees");
    const searchInput = document.getElementById("employeeSearch");
    const dropdown = document.getElementById("employeeDropdown");
    // 🔹 選択済み社員リストの初期化
    if (!window.selectedEmployees) window.selectedEmployees = [];

    function showEmployeeList(listItems) {
        dropdown.innerHTML = "";
        if (!listItems.length) return dropdown.classList.add("hidden");
        dropdown.classList.remove("hidden");
        listItems.forEach(name => {
            const item = document.createElement("div");
            item.className = "px-2 py-1 hover:bg-blue-100 cursor-pointer";
            item.textContent = name;
            item.onclick = () => selectEmployee(name);
            dropdown.appendChild(item);
        });
    }

    searchInput.addEventListener("focus", () => showEmployeeList(allEmployees.filter(e => !window.selectedEmployees.includes(e))));
    searchInput.addEventListener("input", () => {
        const q = searchInput.value.trim();
        const res = allEmployees.filter(e => e.includes(q) && !window.selectedEmployees.includes(e));
        showEmployeeList(res);
    });

    function selectEmployee(name) {
        if (!window.selectedEmployees.includes(name)) window.selectedEmployees.push(name);
        updateSelectedEmployees();
    }

    function updateSelectedEmployees() {
        selectedDiv.innerHTML = "";
        window.selectedEmployees.forEach(name => {
            const tag = document.createElement("div");
            tag.className = "bg-blue-100 text-blue-700 px-2 py-1 rounded flex items-center space-x-1";
            tag.innerHTML = `<span>`+name+`</span> <button class='text-red-500 font-bold'>×</button>`;
            tag.querySelector("button").onclick = () => {
                window.selectedEmployees = window.selectedEmployees.filter(e => e !== name);
                updateSelectedEmployees();
            };
            // console.log("氏名"+name);
            // console.log("追加対象DIV=", selectedDiv);
            // console.log("追加タグHTML=", tag.outerHTML);
            selectedDiv.appendChild(tag);
        });
    }

    function getSelectedEmployees() { return window.selectedEmployees; }

    document.addEventListener("click", e => {
        if (!dropdown.contains(e.target) && e.target !== searchInput) {
            dropdown.classList.add("hidden");
        }
    });

    // ====== チーム管理 ======
    const teamSelect = document.getElementById("teamSelect");
    function loadTeams() {
        const teams = JSON.parse(localStorage.getItem("teams") || "[]");
        teamSelect.innerHTML = '<option value="">-- チームを選択 --</option>';
        teams.forEach(t => {
            const opt = document.createElement("option");
            opt.value = t.name;
            opt.textContent = t.name + "（" + t.members.join("・") + "）";
            teamSelect.appendChild(opt);
        });
    }

    teamSelect.onchange = e => {
        const val = e.target.value;
        const teams = JSON.parse(localStorage.getItem("teams") || "[]");
        const team = teams.find(t => t.name === val);
        if (team) {
            window.selectedEmployees = [...team.members];
            updateSelectedEmployees();
        }
    };

    document.getElementById("btnSaveTeam").onclick = () => {
        const members = getSelectedEmployees();
        if (!members.length) return alert("チームに登録する社員を選択してください。");
        const name = prompt("チーム名を入力してください:");
        if (!name) return;
        let teams = JSON.parse(localStorage.getItem("teams") || "[]");
        teams = teams.filter(t => t.name !== name);
        teams.push({ name, members });
        localStorage.setItem("teams", JSON.stringify(teams));
        loadTeams();
        alert("チームを保存しました。");
    };

    document.getElementById("btnDeleteTeam").onclick = () => {
        const val = teamSelect.value;
        if (!val) return alert("削除するチームを選択してください。");
        let teams = JSON.parse(localStorage.getItem("teams") || "[]");
        teams = teams.filter(t => t.name !== val);
        localStorage.setItem("teams", JSON.stringify(teams));
        loadTeams();
        alert("チームを削除しました。");
    };
    loadTeams();


    // ====== 宿泊制御 ======
    document.getElementById("stayCheck").onchange = e => {
        document.getElementById("hotelName").disabled = !e.target.checked;
        if (!e.target.checked) document.getElementById("hotelName").value = "";
    };

    // ==========================
    // ✅ 表示関数（addRow / addRowNew）
    // ==========================
    function addRow(date, emp, site, proj, type, start, end, dur, hotel, stay, flags = {}) {
        const tr = document.createElement("tr");
        const seq = list.children.length + 1;
        tr.className = flags.inProgress ? "in-progress" : "";

        const moveText = [];
        if (flags.moveIn) moveText.push("本社→現場(" + flags.moveInTime + "分)");
        if (flags.moveBetween) moveText.push("現場→現場(" + flags.moveBetweenTime + "分)");
        if (flags.moveOut) moveText.push("現場→本社(" + flags.moveOutTime + "分)");

        tr.innerHTML =
            "<td class='border text-center'>" + seq + "</td>" +
            "<td class='border text-center'>" + date + "</td>" +
            "<td class='border'>" + emp + "</td>" +
            "<td class='border'>" + site + "</td>" +
            "<td class='border text-center'>" + proj + "</td>" +
            "<td class='border'>" + type + "</td>" +
            "<td class='border text-center start-time'>" + start + "</td>" +
            "<td class='border text-center end-time'>" + end + "</td>" +
            "<td class='border text-center duration'>" + (dur ? dur + "分" : "-") + "</td>" +
            "<td class='border'>" + (stay ? (hotel || "宿泊あり") : "-") + "</td>" +
            "<td class='border text-xs text-gray-600'>" + (moveText.join("<br>") || "-") + "</td>" +
            "<td class='border text-center'><button class='text-red-600'>削除</button></td>";

        // 削除ボタン
        tr.querySelector("button").onclick = function () {
            if (!confirm("本当に削除しますか？")) return;
            tr.remove();
            const all = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");
            const filtered = all.filter(r =>
                !(r.date === date && r.emp === emp && r.site === site &&
                    r.proj === proj && r.type === type && r.start === start && r.end === end)
            );
            localStorage.setItem("attendanceRecords", JSON.stringify(filtered));
            console.log("🗑 削除完了:", date, emp, type);
        };

        list.appendChild(tr);
        return tr;
    }

    function addRowNew(r, inProgress = false) {
        const tr = document.createElement("tr");
        // 背景色設定
        if (inProgress) {
            tr.classList.add("in-progress"); // 黄色：進行中
        } else if (r.type === "移動のみ") {
            tr.classList.add("auto-complete"); // 灰色：自動完結
        } else {
            tr.classList.add("complete"); // 白：完了済み
        }

        const moveText = [];
        if (r.moveIn) moveText.push("本社→現場(" + (r.moveInTime || 0) + "分)");
        if (r.moveBetween) moveText.push("現場→現場(" + (r.moveBetweenTime || 0) + "分)");
        if (r.moveOut) moveText.push("現場→本社(" + (r.moveOutTime || 0) + "分)");

        tr.innerHTML =
            "<td class='border text-center'>" + (list.children.length + 1) + "</td>" +
            "<td class='border text-center'>" + r.date + "</td>" +
            "<td class='border'>" + r.emp + "</td>" +
            "<td class='border'>" + r.site + "</td>" +
            "<td class='border text-center'>" + r.proj + "</td>" +
            "<td class='border'>" + r.type + "</td>" +
            "<td class='border text-center start-time'>" + r.start + "</td>" +
            "<td class='border text-center end-time'>" + r.end + "</td>" +
            "<td class='border text-center duration'>" + (r.duration ? r.duration + "分" : "-") + "</td>" +
            "<td class='border'>" + (r.stay ? (r.hotel || "宿泊あり") : "-") + "</td>" +
            "<td class='border text-xs text-gray-600'>" + (moveText.join("<br>") || "-") + "</td>" +
            "<td class='border text-center'><button class='text-red-600'>削除</button></td>";

        tr.querySelector("button").onclick = function () {
            if (!confirm("本当に削除しますか？")) return;
            tr.remove();
            const all = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");
            const filtered = all.filter(x =>
                !(x.date === r.date && x.emp === r.emp && x.site === r.site &&
                    x.proj === r.proj && x.type === r.type && x.start === r.start && x.end === r.end)
            );
            localStorage.setItem("attendanceRecords", JSON.stringify(filtered));
            console.log("🗑 削除完了:", r.date, r.emp, r.type);
        };

        list.appendChild(tr);
    }

    function saveRecordToLocal(emp, site, proj, type, start, end, duration, stay, hotel, manager) {
        const data = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");
        const record = {
            date: document.getElementById("workDate").value,
            emp, site, proj, type, start, end, duration, stay, hotel,
            manager,
            moveIn: type && type.includes("本社→現場"),
            moveOut: type && type.includes("現場→本社"),
            moveInTime: type && type.includes("本社→現場") ? getStandardTravelTime("hq_to_site") : 0,
            moveOutTime: type && type.includes("現場→本社") ? getStandardTravelTime("site_to_hq") : 0
        };
        data.push(record);
        localStorage.setItem("attendanceRecords", JSON.stringify(data));
    }

    /* --- 責任者⇄一般切替 --- */
    let currentUserName=localStorage.getItem("userName")||"宮本 義史";
    let userRole=localStorage.getItem("userRole")||(currentUserName==="宮本 義史"?"manager":"staff");


    function applyRole(){
        const roleBtn=document.getElementById("roleSwitchBtn");
        const searchInput=document.getElementById("employeeSearch");
        const dropdown=document.getElementById("employeeDropdown");
        const teamSelect=document.getElementById("teamSelect");
        const btnSave=document.getElementById("btnSaveTeam");
        const SaveTeamDivTemp=document.getElementById("teamTeamdiv");
        const btnDel=document.getElementById("btnDeleteTeam");
        const pageTitleText=document.getElementById("pageTitle");
        const managerShowText=document.getElementById("managerShow");


        if(userRole==="manager"){
            currentUserName="宮本 義史";
            roleBtn.textContent="切替：一般ユーザ";
            pageTitleText.textContent="(責任者)打刻";
            [searchInput,dropdown,teamSelect,btnSave,btnDel,SaveTeamDivTemp,managerShowText].forEach(el=>{if(el)el.style.display="";});
        }else{
            currentUserName="川本 浩史";
            roleBtn.textContent="切替：責任者";
            pageTitleText.textContent="打刻";
            [searchInput,dropdown,teamSelect,btnSave,btnDel,SaveTeamDivTemp,managerShowText].forEach(el=>{if(el)el.style.display="none";});
        }
        localStorage.setItem("userName",currentUserName);
        localStorage.setItem("userRole",userRole);
        window.selectedEmployees=[currentUserName];
        updateSelectedEmployees();
    }
    document.getElementById("roleSwitchBtn").onclick=()=>{
        userRole=userRole==="manager"?"staff":"manager";
        applyRole();
    };
    applyRole();

    /* --- 打刻開始・終了 --- */
    document.getElementById("btnStart").onclick = () => {
        const employees = getSelectedEmployees();
        if (!employees.length) return alert("社員を選択してください。");
        const hasWork = document.querySelector('input[name="hasWork"]:checked').value;
        const moveTypes = [...document.querySelectorAll('input[name="moveType"]:checked')].map(e => e.value);
        const date = document.getElementById("workDate").value;
        const site = document.getElementById("siteSelect").value;
        const proj = document.getElementById("projectSelect").value;
        const stay = document.getElementById("stayCheck").checked;
        const hotelInput = document.getElementById("hotelName").value.trim(); // 入力値（空なら"宿泊あり"）
        const hotel = stay ? (hotelInput || "宿泊あり") : "-";       // ✅ 表示用ホテル名
        const now = getCurrentTime();
        const start = formatTime(now.h, now.m);
        console.log("stay= "+stay);

        employees.forEach(emp => {
            if (activeEmployees[emp]) return alert( emp+`さんはすでに開始済みです。`);
            // === 作業あり（通常パターン） ===
            if (hasWork === "yes") {
                const rec = {
                    date, emp, site, proj,
                    start, end: "-", duration: 0,
                    stay, hotel,
                    moveIn: moveTypes.includes("hq_to_site"),
                    moveInTime: moveTypes.includes("hq_to_site") ? getStandardTravelTime("hq_to_site") : 0,
                    moveBetween: moveTypes.includes("site_to_site"),
                    moveBetweenTime: moveTypes.includes("site_to_site") ? getStandardTravelTime("site_to_site") : 0,
                    moveOut: moveTypes.includes("site_to_hq"),
                    moveOutTime: moveTypes.includes("site_to_hq") ? getStandardTravelTime("site_to_hq") : 0,
                    type: "作業",
                    manager: managerName
                };

                saveAttendanceRecord(rec);
                syncToMonthlyRecords(rec); // ✅ ← これを追加
                addRowNew(rec, true); // 進行中（in-progress）
                activeEmployees[emp] = rec;
                localStorage.setItem("activeEmployees", JSON.stringify(activeEmployees));

                console.log("▶ 作業開始:", emp, start);
            }            // === 作業なし（移動のみ or 宿泊のみ）===
            else {
                const baseMinutes = getStandardTravelTime("hq_to_site"); // デフォルト45分
                const endObj = addMinutes(now.h, now.m, baseMinutes);
                const end = formatTime(endObj.h, endObj.m);

                const rec = {
                    date, emp, site, proj,
                    start, end, duration: baseMinutes,
                    stay, hotel,
                    moveIn: moveTypes.includes("hq_to_site"),
                    moveInTime: moveTypes.includes("hq_to_site") ? baseMinutes : 0,
                    moveBetween: moveTypes.includes("site_to_site"),
                    moveBetweenTime: moveTypes.includes("site_to_site") ? baseMinutes : 0,
                    moveOut: moveTypes.includes("site_to_hq"),
                    moveOutTime: moveTypes.includes("site_to_hq") ? baseMinutes : 0,
                    type: "移動のみ",
                    manager: managerName
                };

                saveAttendanceRecord(rec);
                syncToMonthlyRecords(rec); // ✅ ← これを追加
                addRowNew(rec, false); // 完了済みなのでin-progress不要

                console.log("✅ 作業なしレコード完了:", emp, start, "→", end);
            }

        });
    };

    // ====== 終了処理 ======
    document.getElementById("btnEnd").onclick = () => {
        const employees = getSelectedEmployees();
        if (!employees.length) return alert("終了する社員を選択してください。");

        const moveTypesNow = [...document.querySelectorAll('input[name="moveType"]:checked')].map(e => e.value);
        const now = getCurrentTime();
        const end = formatTime(now.h, now.m);
        const stayChecked = document.getElementById("stayCheck").checked;
        const hotelName = document.getElementById("hotelName").value;
        const date = document.getElementById("workDate").value;

        employees.forEach(emp => {
            const active = activeEmployees[emp];
            if (!active) return alert(emp + " さんは開始されていません。");

            // ✅ localStorageの全レコード取得
            const records = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");

            // ✅ 未終了レコード（end が "-" または空）の中で最新のものを探す
            const idx = records
                .map((r, i) => ({...r, _i: i}))
                .filter(r => r.emp === emp && r.date === date && (!r.end || r.end === "-"))
                .sort((a, b) => timeToMinutes(b.start) - timeToMinutes(a.start))[0]?._i;

            if (idx === undefined) {
                alert(emp + " さんの未終了レコードが見つかりません。");
                return;
            }

            // ✅ レコード更新
            const rec = records[idx];
            rec.end = end;
            rec.duration = calcDuration(rec.start, end);

            // ✅ 現場→本社 の移動チェック
            rec.moveOut = moveTypesNow.includes("site_to_hq");
            rec.moveOutTime = rec.moveOut ? DEFAULT_MOVE_TIME : 0;

            // ✅ 宿泊状態反映
            rec.stay = stayChecked;
            rec.hotel = stayChecked ? (hotelName || "宿泊あり") : "-";

            // ✅ 上書き保存
            records[idx] = rec;
            localStorage.setItem("attendanceRecords", JSON.stringify(records));
            syncToMonthlyRecords(rec); // ✅ ← 終了時も反映（丸めして保存）

            // ✅ 画面側の該当行を更新
            const tr = [...list.querySelectorAll("tr")].find(r =>
                r.children[2].textContent === emp &&
                r.children[5].textContent === rec.type &&
                r.querySelector(".end-time").textContent === "-"
            );
            if (tr) {
                tr.querySelector(".end-time").textContent = end;
                const s = tr.querySelector(".start-time").textContent;
                tr.querySelector(".duration").textContent = calcDuration(s, end) + "分";
                tr.classList.remove("in-progress");
            }

            // ✅ activeから削除
            delete activeEmployees[emp];
            localStorage.setItem("activeEmployees", JSON.stringify(activeEmployees));

            console.log("✅ 終了更新:", emp, rec.date, rec.type, "→", rec.duration + "分");
        });
    };

    // ✅ localStorage に保存する関数
    function saveAttendanceRecord(newData) {
        let all = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");

        // === 未終了チェック ===
        const unfinished = all.find(r =>
            r.emp === newData.emp &&
            r.date === newData.date &&
            (!r.end || r.end === "-" || r.duration === 0)
        );

        if (unfinished) {
            alert("⚠️ 「" + newData.emp + "」さんの未終了レコードがあります。終了してから新しい作業を開始してください。");
            console.warn("未終了レコード:", unfinished);
            return false; // 保存中止
        }

        // === 正常登録 ===
        all.push(newData);
        localStorage.setItem("attendanceRecords", JSON.stringify(all));
        console.log("保存完了:", newData.emp, newData.date, newData.type);
        return true;
    }

    // ===== monthlyRecords 同期（開始・終了共通） =====
    function syncToMonthlyRecords(rec) {
        const monthly = JSON.parse(localStorage.getItem("monthlyRecords") || "[]");

        // 🔹 丸め
        const adjStart = roundTo15Up(rec.start);
        const adjEnd = rec.end && rec.end !== "-" ? roundTo15Down(rec.end) : "";

        // 🔹 複数レコード対応（同日・同現場・同案件でも別登録）
        const keyFields = ["emp", "date", "site", "proj", "start"];
        const isSameRec = (r1, r2) =>
            keyFields.every(k => (r1[k] || "") === (r2[k] || ""));

        const idx = monthly.findIndex(r => isSameRec(r, rec));

        const newRec = {
            ...rec,
            adjustedStart: adjStart,
            adjustedEnd: adjEnd,
            selfConfirmed: rec.selfConfirmed || false,
            managerConfirmed: rec.managerConfirmed || false,
            managerComment: rec.managerComment || "",
            confirmedBy: rec.confirmedBy || "",
            confirmedAt: rec.confirmedAt || ""
        };

        if (idx >= 0) {
            monthly[idx] = { ...monthly[idx], ...newRec };
        } else {
            monthly.push(newRec);
        }

        localStorage.setItem("monthlyRecords", JSON.stringify(monthly));
        console.log("🗂 monthlyRecords更新:", newRec.emp, newRec.date, newRec.type);
    }

</script>
</body>
</html>
