const siPrefixes = "KMGTPEZY";

export default function quantify(bytes, options = {}) {
  let base = options.base || 1024
  let pow  = options.pow  || 0

  let i = parseInt(bytes) * Math.pow(base, pow);
  let e = Math.log(i) / Math.log(base) | 0;
  let val = i / Math.pow(base, e);

  return {
    val:    val,
    factor: (e>0 ? siPrefixes[e - 1] : '')
  };
}
