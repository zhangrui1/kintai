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
                console.log("Number.isFinite(diff) =" +Number.isFinite(diff));
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
