require 'delorean_lang'

class MartyDemo::Helper
  include Delorean::Model

  delorean_fn :to_csv, sig: [1, 2] do
    |*args|

    # NOTE: can't use |data, config| due to delorean_fn weirdness.
    data, config = args

    Marty::DataExporter.to_csv(data, config)
  end

  JSV_SEP = "\t"

  # JSON separated values
  delorean_fn :to_jsv, sig: 1 do
    |data|
    raise "arg must be string" unless data.is_a? Hash

    h = data.each_with_object({}) do
      |(k,v), h|
      raise "non-string hash key #{k}" unless k.is_a? String

      h[k] = case v
             when String
               # add JSV_SEP to string so it forces quoting
               "#{v}#{JSV_SEP}#{JSV_SEP}"
             when BigDecimal
               v.to_s
             when Numeric, nil, TrueClass, FalseClass
               v
             else
               raise "unsupported JSV value type for #{v}"
             end
    end

    BidTrack::Helper.to_csv(h, "col_sep" => JSV_SEP).
      gsub('""', '').
      gsub(/#{JSV_SEP}#{JSV_SEP}\"/, '"')
  end

  delorean_fn :parse_jsv, sig: 1 do
    |txt|

    a = CSV.parse(txt, headers: false, col_sep: JSV_SEP, quote_char: 30.chr)

    a_values = a.map do
      |k,v|
      case v
      when nil, "NULL"
        "null"
      when "TRUE", "FALSE", "True", "False"
        v.downcase
      else
        v
      end
    end.join(',')

    values = JSON.parse("[#{a_values}]")

    h = {}
    a.each_with_index { |(k,v), i| h[k] = values[i] }
    h
  end

  # Just for testing
  delorean_fn :p, sig: [0, 20] do
    |*args|
    Kernel.p args
  end

  # Just for testing
  delorean_fn :sleep, sig: 1 do
    |seconds|
    Kernel.sleep seconds
  end

  delorean_fn :hash_array_merge, sig: 2 do
    |hl, transpose|

    raise "non hash-array argument" unless
      hl.map {|x| x.is_a? Hash}.all?

    Marty::DataExporter.hash_array_merge(hl, transpose)
  end

  # Hacky to have this here. It's a general utility function.  This
  # would be a major pain to write in Delorean now.
  delorean_fn :hash_array_max, sig: 2 do
    |array, by|

    array.detect { |x| x[by] == array.map {|x| x[by]}.max }
  end

  # sorting hash based on key (by)
  delorean_fn :hash_array_sort_by, sig: 2 do
    |array, by|

    array.sort_by { |k| k[by] }
  end

  delorean_fn :hash_array_group_by, sig: 2 do
    |array, by|

    array.group_by { |k| k[by] }
  end

  delorean_fn :hash_sort_keys, sig: 1 do
    |h|
    Hash[h.sort]
  end

  delorean_fn :range_step, sig: 3 do
    |rstart, rend, step|
    (rstart..rend).step(step).to_a
  end

  delorean_fn :parse_to_localtime, sig: 1 do
    |dt_str|
    raise "arg must be string" unless dt_str.is_a? String
    DateTime.parse(dt_str).in_time_zone(Rails.configuration.time_zone)
  end

  delorean_fn :now, sig: 0 do
    DateTime.now
  end

  delorean_fn :infinity_dt, sig: 1 do
    |pt|
    Mcfly.is_infinity pt
  end

  delorean_fn :utc_dt, sig: 1 do
    |dt|
    dt.utc
  end

  delorean_fn :calculate_offsets, sig: 6 do
    |sets, sets_per_row, hinit, vinit, hgap, vgap|

    voffsets, offset, step  = {}, vinit, 0

    while step < sets.length()
      # Stores the vertical offset at each step, i.e for each row.
      voffsets[step] = offset

      # Finds the length of the longest set on the row and adds the
      # vertical gap.
      offset += sets[step...step+sets_per_row].map(&:length).max() + vgap
      step += sets_per_row
    end

    x, y, count, step = hinit, vinit, 1, 0
    sets.map do |set|
      next unless set.is_a?(Array) &&
        set.all? {|s| s.is_a?(Array) && s[1].is_a?(Array)}

      pos_set = ["pos", [x, y], set]

      if count < sets.length()
        step += sets_per_row if count % sets_per_row == 0
        y = voffsets[step]
        x = count % sets_per_row == 0 ? hinit : x + set[0][1].length() + hgap
        count += 1
      end

      pos_set
    end
  end

  delorean_fn :vwap, sig: 2 do
    |vl, pl|

    raise "args must be arrays" unless
      vl.is_a?(Array) && pl.is_a?(Array)

    raise "args must be same length" unless
      vl.length == pl.length

    vsum = vl.sum.to_f

    next nil if vsum == 0

    xsum = vl.zip(pl).map { |a,b| a*b }.sum
    xsum / vsum
  end

  delorean_fn :i18n, sig: 1 do
    |s|
    raise "arg must be string" unless s.is_a? String
    I18n.t(s)
  end

  delorean_fn :parse_json, sig: 1 do
    |s|
    raise "arg must be string" unless s.is_a? String
    JSON.decode(s)
  end

  # support for import type security
  delorean_fn :import_data, sig: 2 do
    |import_type, data|

    data.gsub!(/\0/,'')
    raise "Insufficient permissions to run the data import" unless
      import_type.allow_import?

    Marty::DataImporter.do_import_summary(import_type.get_model_class,
                                          data,
                                          'infinity',
                                          import_type.cleaner_function,
                                          import_type.validation_function,
                                          "\t",
                                          false)
  end
end
