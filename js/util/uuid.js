/**
 * UUIDUtil.getUUID(),获取唯一标识
 * eg:"C66494AC-FF80-0002-DC41-1DC311361B0E"
 */
(function(window) {
    window.UUIDUtil = {
        getUUID : createUUID
    };
    function createUUID() {
        var dg = new Date(1582, 10, 15, 0, 0, 0, 0);
        var dc = new Date();
        var t = dc.getTime() - dg.getTime();
        var tl = getIntegerBits(t, 0, 31);
        var tm = getIntegerBits(t, 32, 47);
        var thv = getIntegerBits(t, 48, 59) + '2';
        var csar = getIntegerBits(rand(4095), 0, 7);
        var csl = getIntegerBits(rand(4095), 0, 7);

        // since detection of anything about the machine/browser is far to
        // buggy, include some more random numbers here if NIC or an IP can be
        // obtained reliably, that should be put in here instead.
        var n = getIntegerBits(rand(8191), 0, 7) 
                    + getIntegerBits(rand(8191), 8, 15) 
                    + getIntegerBits(rand(8191), 0, 7)
                    + getIntegerBits(rand(8191), 8, 15) 
                    + getIntegerBits(rand(8191), 0, 15); 
        return tl + "-" + tm + "-" + thv + "-" + csar + csl + "-" + n;
    }

    //
    // GENERAL METHODS (Not instance specific)
    //
    // Pull out only certain bits from a very large integer, used to get the
    // time code information for the first part of a UUID. Will return zero's if
    // there  aren't enough bits to shift where it needs to.
    getIntegerBits = function(val, start, end) {
        var base16 = returnBase(val, 16);
        var quadArray = new Array();
        var quadString = '';
        var i = 0;
        for (i = 0; i < base16.length; i++) {
            quadArray.push(base16.substring(i, i + 1));
        }
        for (i = Math.floor(start / 4); i <= Math.floor(end / 4); i++) {
            if (!quadArray[i] || quadArray[i] == '')
                quadString += '0';
            else
                quadString += quadArray[i];
        }
        return quadString;
    };

    // Replaced from the original function to leverage the built in methods in
    // JavaScript. Thanks to Robert Kieffer for pointing this one out
    returnBase = function(number, base) {
        return (number).toString(base).toUpperCase();
    };

    // pick a random number within a range of numbers
    // int b rand(int a); where 0 <= b <= a
    rand = function(max) {
        return Math.floor(Math.random() * (max + 1));
    };

})(window);