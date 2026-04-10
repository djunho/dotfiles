
# Fix the cedilha on US international keyboard layout. By default, the US International layout allows you to type
# accented characters by using dead keys. However, it does not provide a way to type the cedilla (ç) directly.
# This code snippet adds a mapping for the cedilla character when using the US International keyboard layout.

if [ -z "$(grep "Cedilla fix for US International keyboard" ~/.XCompose)" ]; then
    echo '' >> ~/.XCompose
    echo '# Cedilla fix for US International keyboard' >> ~/.XCompose
    echo '<dead_acute> <C> : "Ç"' >> ~/.XCompose
    echo '<dead_acute> <c> : "ç"' >> ~/.XCompose
fi
