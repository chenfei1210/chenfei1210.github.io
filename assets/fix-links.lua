function Link(el)
  -- 如果链接包含 .md 或 .md#xxx，替换为 .html 或 .html#xxx
  el.target = el.target:gsub("%.md(%#?[^%?]*)$", ".html%1")
  return el
end