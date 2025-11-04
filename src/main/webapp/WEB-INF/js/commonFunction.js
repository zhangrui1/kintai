// 小計の共通部分
function appendSubtotalRow(tbody, label, records) {
    let moveMin = 0, workMin = 0;

    records.forEach(r => {
        // --- 移動時間合計（分） ---
        const movePart =
            (r.moveIn ? (r.moveInTime || 0) : 0) +
            (r.moveBetween ? (r.moveBetweenTime || 0) : 0) +
            (r.moveOut ? (r.moveOutTime || 0) : 0);
        if (Number.isFinite(movePart)) moveMin += movePart;

        // --- 勤怠（調整後）による作業時間 ---
        if (r.type !== "移動のみ") {
            const adjStart = r.adjustedStart || (r.start ? roundTo15Up(r.start) : "");
            const adjEnd   = r.adjustedEnd   || (r.end   ? roundTo15Down(r.end) : "");

            if (adjStart && adjEnd) {
                let diff = timeToMin(adjEnd) - timeToMin(adjStart);
                if (!Number.isFinite(diff)) return; // NaNはスキップ
                if (diff < 0) diff += 1440; // 翌日対応
                if (diff > 360) diff -= 60; // 6h超は休憩1h控除
                if (Number.isFinite(diff)) workMin += diff;
            }
        }
    });

    // --- 丸め処理 ---
    const moveTotal = Number.isFinite(moveMin) ? moveMin / 60 : 0;
    const workTotal = Number.isFinite(workMin) ? workMin / 60 : 0;
    const totalAll = moveTotal + workTotal;

    // --- 丸めと整形 ---
    const f = n => {
        if (!Number.isFinite(n) || n === 0) return "0";
        const val = Math.round(n * 100) / 100;
        return (val % 1 === 0 ? val.toFixed(0) : val.toFixed(2))
            .replace(/0$/, "")
            .replace(/\.0$/, "");
    };

    // --- 小計行を作成 ---
    const foot = document.createElement("tr");
    foot.className = "subrow";
    foot.innerHTML =
        "<td colspan='12' class='border px-3 py-1 text-right'>⤵ " + label + " 合計</td>" +
        "<td class='border px-3 py-1 font-semibold'>" + f(moveTotal) + "時間</td>" +
        "<td class='border px-3 py-1 font-semibold'>" + f(workTotal) + "時間</td>" +
        "<td class='border px-3 py-1 font-semibold'>" + f(totalAll) + "時間</td>" +
        "<td colspan='4' class='border px-3 py-1'></td>";

    tbody.appendChild(foot);
}
/**
 * 月次データの編集内容を localStorage に保存する
 * @param {object} rec - 編集対象のレコード（1行分）
 */
function saveMonthlyEdit(rec) {
    if (!rec || !rec.emp || !rec.date) return;

    // 現在のデータ取得
    const all = JSON.parse(localStorage.getItem("monthlyRecords") || "[]");

    // 同じ日付・社員の既存データを検索
    const idx = all.findIndex(r =>
        r.emp === rec.emp &&
        r.date === rec.date &&
        r.proj === rec.proj // 案件番号で区別
    );

    if (idx >= 0) {
        // 既存レコードを更新
        all[idx] = { ...all[idx], ...rec };
    } else {
        // 存在しない場合は新規追加（例：打刻→月次初期生成時など）
        all.push(rec);
    }

    // 上書き保存
    localStorage.setItem("monthlyRecords", JSON.stringify(all));
    console.log("monthlyRecords",JSON.stringify(all));

    // ついでに attendanceRecords も同期（必要なら）
    const allAtt = JSON.parse(localStorage.getItem("attendanceRecords") || "[]");
    const aidx = allAtt.findIndex(r =>
        r.emp === rec.emp &&
        r.date === rec.date &&
        r.proj === rec.proj
    );
    if (aidx >= 0) {
        allAtt[aidx] = { ...allAtt[aidx], ...rec };
        localStorage.setItem("attendanceRecords", JSON.stringify(allAtt));
    }
}

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