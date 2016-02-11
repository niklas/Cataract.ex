import Ember from 'ember';
import quantify from 'cataract/utils/quantify';

export function humanKiloBytes(value, meta) {
  let options = meta.hash || {};
  let short    = options.short || false;
  let decimals = options.decimals || 1;
  let base     = options.base || 1024;

  let quant = quantify(value, options);

  let unit = short ? 'B' : 'Bytes';
  if (base === 1024) {
    unit = 'i' + unit;
  }

  let val = quant.val > 0 ? quant.val.toFixed(decimals) : '???';
  return val +
    (short ? '' : ' ') +
    quant.factor +
    unit;
}

export default Ember.Helper.helper(humanKiloBytes);
