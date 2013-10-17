require 'test_helper'

class HelpersTest < MiniTest::Unit::TestCase

  ### Column ########################################################

  def test_empty_col
    assert_equal(<<HTML, render(<<HAML))
<td>
</td>
HTML
= col
HAML
  end

  def test_col_spacer
    assert_equal(<<HTML, render(<<HAML))
<td style='width: 9px;' width='9'>
</td>
HTML
= col(:spacer => 9)
HAML
  end

  def test_col_hspace
    assert_equal(<<HTML, render(<<HAML))
<td style='width: 9px;' width='9'>
</td>
HTML
= col(:hspace => 9)
HAML
  end

  def test_col_vspace
    assert_equal(<<HTML, render(<<HAML))
<td height='9' style='height: 9px;'>
</td>
HTML
= col(:vspace => 9)
HAML
  end

  def test_style
    assert_equal(<<HTML, render(<<HAML))
<td style='prop1: foo; prop2: bar;width: 9px;' width='9'>
</td>
HTML
= col(:hspace => 9, :style => "prop1: foo; prop2: bar;")
HAML
  end

  ### Row ###########################################################

  def test_empty_row
    assert_equal(<<HTML, render(<<HAML))
<tr>
  <td>
  </td>
</tr>
HTML
= row
HAML
  end

  def test_row_with_col
    assert_equal(<<HTML, render(<<HAML))
<tr>
  <td>
    Foobar
  </td>
</tr>
HTML
= row do
  = col do
    = "Foobar"
HAML
  end

  def test_row_without_col
    assert_equal(<<HTML, render(<<HAML))
<tr>
  <td>
    Foobar
  </td>
</tr>
HTML
= row do
  = "Foobar"
HAML
  end

  def test_row_spacer
    assert_equal(<<HTML, render(<<HAML))
<tr>
  <td height='9' style='height: 9px;'>
  </td>
</tr>
HTML
= row(:spacer => 9)
HAML
  end

  def test_row_hspace
    assert_equal(<<HTML, render(<<HAML))
<tr>
  <td style='width: 9px;' width='9'>
  </td>
</tr>
HTML
= row(:hspace => 9)
HAML
  end

  def test_row_vspace
    assert_equal(<<HTML, render(<<HAML))
<tr>
  <td height='9' style='height: 9px;'>
  </td>
</tr>
HTML
= row(:vspace => 9)
HAML
  end

  def test_row_rowspan
    assert_equal(<<HTML, render(<<HAML))
<tr>
  <td rowspan='3'>
  </td>
</tr>
HTML
= row(:rowspan => 3)
HAML
  end

  def test_row_colspan
    assert_equal(<<HTML, render(<<HAML))
<tr>
  <td colspan='3'>
  </td>
</tr>
HTML
= row(:colspan => 3)
HAML
  end

  ### Container #####################################################

  def test_empty_container
    assert_equal(<<HTML, render(<<HAML))
<table align='center' border='0' cellpadding='0' cellspacing='0' style='margin-left: auto; margin-right: auto;' width='100%'>
  <tr>
    <td>
    </td>
  </tr>
</table>
HTML
= container
HAML
  end

  def test_container_with_row
    assert_equal(<<HTML, render(<<HAML))
<table align='center' border='0' cellpadding='0' cellspacing='0' style='margin-left: auto; margin-right: auto;' width='100%'>
  <tr>
    <td>
      Foobar
    </td>
  </tr>
</table>
HTML
= container do
  = row do
    = "Foobar"
HAML
  end

  def test_container_without_row
    assert_equal(<<HTML, render(<<HAML))
<table align='center' border='0' cellpadding='0' cellspacing='0' style='margin-left: auto; margin-right: auto;' width='100%'>
  <tr>
    <td>
      Foobar
    </td>
  </tr>
</table>
HTML
= container do
  = col do
    = "Foobar"
HAML
  end

  ### Comprehensive Tests ###########################################

  def test_simple_example
    haml = IO.read(File.dirname(__FILE__) + '/haml/simple.haml')
    html = IO.read(File.dirname(__FILE__) + '/html/simple.html')
    assert_equal html, render(haml)
  end

  def test_complicated_example
    haml = IO.read(File.dirname(__FILE__) + '/haml/complicated.haml')
    html = IO.read(File.dirname(__FILE__) + '/html/complicated.html')
    assert_equal html, render(haml)
  end

end
