<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<html lang="ja">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>現場作業入力</title>
    <script src="https://cdn.tailwindcss.com"></script>

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
        .in-progress {
            background-color: #fef3c7; /* yellow-100 */
            font-style: italic;
        }
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

    /* --- 初期表示 --- */
    window.addEventListener("DOMContentLoaded",()=>{
        loadTeams();
        applyRole();

        const today=new Date();
        const yyyy=today.getFullYear(),mm=String(today.getMonth()+1).padStart(2,"0"),dd=String(today.getDate()).padStart(2,"0");
        const todayStr = yyyy + "-" + mm + "-" + dd;
        const all=JSON.parse(localStorage.getItem("attendanceRecords")||"[]");
        all.filter(r=>r.date===todayStr).forEach(r=>addRowNew(r,false));
        for(const emp in activeEmployees){(activeEmployees[emp],true);}
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
        if (["hq_to_site", "site_to_hq"].includes(t)) return 45;
        if (t === "site_to_site") return 30;
        return 0;
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



    /* --- 日付自動設定 --- */
    function todayStr() {
        const d = new Date();
        var temp = d.getFullYear() + "-" +
            String(d.getMonth() + 1).padStart(2, "0") + "-" +
            String(d.getDate()).padStart(2, "0");
        console.log("今日の日付＝ " + temp);
        return temp;
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

    /* --- 表示関数 --- */
    function addRow(date, emp, site, proj, type, start, end, dur, hotel, stay) {
        const tr = document.createElement("tr");
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
            "<td class='border text-center'><button class='text-red-600'>削除</button></td>";
        // ✅ 削除ボタン処理
        tr.querySelector("button").onclick = function() {
            // 1. 画面から削除
            tr.remove();

            // 2. localStorageから削除
            const all = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");

            // 一意性を保つため複数条件で一致チェック（必要に応じてカスタマイズ）
            const filtered = all.filter(r =>
                !(
                    r.date === date &&
                    r.emp === emp &&
                    r.site === site &&
                    r.proj === proj &&
                    r.type === type &&
                    r.start === start &&
                    r.end === end
                )
            );

            // 3. 保存し直す
            localStorage.setItem("attendanceRecords", JSON.stringify(filtered));
            console.log("削除完了:", date, emp, site, proj, type, start);
        };
        list.appendChild(tr);
        sortEntryList();
        return tr;
    }

    /* --- 表示関数（新） --- */
    function addRowNew(r, inProgress = false) {
        const tr = document.createElement("tr");
        if (inProgress) tr.classList.add("in-progress");
        tr.innerHTML =
            "<td class='border text-center'>" + (entryList.children.length + 1) + "</td>" +
            "<td class='border text-center'>" + r.date + "</td>" +
            "<td class='border'>" + r.emp + "</td>" +
            "<td class='border'>" + r.site + "</td>" +
            "<td class='border text-center'>" + r.proj + "</td>" +
            "<td class='border'>" + r.type + "</td>" +
            "<td class='border text-center start-time'>" + r.start + "</td>" +
            "<td class='border text-center end-time'>" + r.end + "</td>" +
            "<td class='border text-center duration'>" + (r.duration ? r.duration + "分" : "-") + "</td>" +
            "<td class='border'>" + (r.stay ? (r.hotel || "宿泊あり") : "-") + "</td>" +
            "<td class='border text-center'><button class='text-red-600'>削除</button></td>";
        // ✅ 削除ボタン処理を追加
        tr.querySelector("button").onclick = function () {
            // ① 表示上から削除
            tr.remove();

            // ② localStorageから削除
            const all = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");

            // 該当レコードを除外
            const filtered = all.filter(x =>
                !(
                    x.date === r.date &&
                    x.emp === r.emp &&
                    x.site === r.site &&
                    x.proj === r.proj &&
                    x.type === r.type &&
                    x.start === r.start &&
                    x.end === r.end
                )
            );

            // ③ localStorageへ再保存
            localStorage.setItem("attendanceRecords", JSON.stringify(filtered));
            console.log("削除完了:", r.date, r.emp, r.site, r.proj);
        };
        list.appendChild(tr);
        sortEntryList();
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
    const managerName="宮本 義史";

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
        const hotel = document.getElementById("hotelName").value;
        const now = getCurrentTime();
        console.log("now time="+ JSON.stringify(now));
        const start = formatTime(now.h, now.m);

        employees.forEach(emp => {
            if (activeEmployees[emp]) return alert( emp+`さんはすでに開始済みです。`);
            const baseRecord = {
                date, emp, site, proj, start, end: "-", duration: 0,
                stay: stay ? (hotel || "宿泊あり") : "-",
                moveIn: moveTypes.includes("hq_to_site"),
                moveInTime: moveTypes.includes("hq_to_site") ? getStandardTravelTime("hq_to_site") : 0,
                moveOut: moveTypes.includes("site_to_hq"),
                moveOutTime: moveTypes.includes("site_to_hq") ? getStandardTravelTime("site_to_hq") : 0,
                manager: "宮本 義史"
            };

            if (moveTypes.includes("hq_to_site")) {
                const min = getStandardTravelTime("hq_to_site");
                const moveStart = subtractMinutes(now.h, now.m, min);
                addRow(date, emp, site, proj, "移動(本社→現場)", "-", "-", 45, hotel, stay);
                saveRecordToLocal(emp, site, proj, "移動(本社→現場)", "-", "-", 45, stay, hotel, managerName);
            }

            if (hasWork === "yes") {
                addRow(date, emp, site, proj, "作業", start, "-", 0, hotel, stay);
                saveRecordToLocal(emp, site, proj, "作業", start, "-", 0, stay, hotel, managerName);
            } else {
                addRow(date, emp, site, proj, "移動のみ", start, "-", 0, hotel, stay);
                saveRecordToLocal(emp, site, proj, "移動のみ", start, "-", 0, stay, hotel, managerName);
            }

            if (moveTypes.includes("site_to_site")) {
                const min = getStandardTravelTime("site_to_site");
                const moveStart = subtractMinutes(now.h, now.m, min);
                addRow(date, emp, site, proj, "移動(現場→現場)", formatTime(moveStart.h, moveStart.m), start, min, hotel, stay);
                saveRecordToLocal(emp, site, proj, "移動(現場→現場)", formatTime(moveStart.h, moveStart.m), start, min, stay, hotel, managerName);
            }
              //宿泊の行を表示しないように変更
            // if (stay) {
            //     addRow(date, emp, site, proj, "宿泊", "-", "-", 0, hotel, stay);
            //     saveRecordToLocal(emp, site, proj, "宿泊", "-", "-", 0, stay, hotel, managerName);
            // }


            activeEmployees[emp] = { start, site, proj, stay, hotel, manager: managerName };
            localStorage.setItem("activeEmployees", JSON.stringify(activeEmployees));
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

        employees.forEach(emp => {
            const rec = activeEmployees[emp];
            if (!rec) return alert(emp+` さんは開始されていません。`);

            // 作業行を終了
            const tr = [...list.querySelectorAll("tr")].find(r =>
                r.children[2].textContent === emp &&
                r.children[5].textContent === "作業" &&
                r.querySelector(".end-time").textContent === "-"
            );
            if (tr) {
                tr.querySelector(".end-time").textContent = end;
                const s = tr.querySelector(".start-time").textContent;
                tr.querySelector(".duration").textContent = calcDuration(s, end) + "分";
            }

            // 現場→本社
            if (moveTypesNow.includes("site_to_hq")) {
                const min = getStandardTravelTime("site_to_hq");
                const moveEnd = addMinutes(now.h, now.m, min);
                addRow(date, emp, rec.site, rec.proj, "移動(現場→本社)",  "-", "-", 45, min, rec.hotel, rec.stay);
                saveRecordToLocal(emp, rec.site, rec.proj, "移動(現場→本社)",  "-", "-", 45, rec.stay, rec.hotel, managerName);
            }

            // 宿泊反映（終了時）
            const existingStay = [...document.querySelectorAll("#entryList tr")].find(
                r => r.children[2].textContent === emp && r.children[5].textContent === "宿泊"
            );

            if (stayChecked && !existingStay) {
                addRow(document.getElementById("workDate").value, emp, rec.site, rec.proj, "宿泊", "-", "-", 0, hotelName, true);
                saveRecordToLocal(emp, rec.site, rec.proj, "宿泊", "-", "-", 0, true, hotelName, managerName);
            } else if (!stayChecked && existingStay) {
                existingStay.remove();
            }


            delete activeEmployees[emp];
            // ✅ 終了時、localStorage内の該当レコード更新
            const records = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");
            const recIndex = records.findIndex(r => r.emp === emp && r.date === document.getElementById("workDate").value && r.type === "作業");
            if (recIndex !== -1) {
                records[recIndex].end = end;
                records[recIndex].duration = calcDuration(records[recIndex].start, end);
            }
            localStorage.setItem("attendanceRecords", JSON.stringify(records));

        });
    };

    // ✅ localStorage に保存する関数
    function saveAttendanceRecord(record) {
        const records = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");
        records.push(record);
        localStorage.setItem("attendanceRecords", JSON.stringify(records));
        console.log("保存:", record);
    }


</script>
</body>
</html>
