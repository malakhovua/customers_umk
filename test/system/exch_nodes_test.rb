require "application_system_test_case"

class ExchNodesTest < ApplicationSystemTestCase
  setup do
    @exch_node = exch_nodes(:one)
  end

  test "visiting the index" do
    visit exch_nodes_url
    assert_selector "h1", text: "Exch Nodes"
  end

  test "creating a Exch node" do
    visit exch_nodes_url
    click_on "New Exch Node"

    fill_in "Cat", with: @exch_node.cat
    fill_in "Node", with: @exch_node.node
    fill_in "Ser", with: @exch_node.ser
    click_on "Create Exch node"

    assert_text "Exch node was successfully created"
    click_on "Back"
  end

  test "updating a Exch node" do
    visit exch_nodes_url
    click_on "Edit", match: :first

    fill_in "Cat", with: @exch_node.cat
    fill_in "Node", with: @exch_node.node
    fill_in "Ser", with: @exch_node.ser
    click_on "Update Exch node"

    assert_text "Exch node was successfully updated"
    click_on "Back"
  end

  test "destroying a Exch node" do
    visit exch_nodes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Exch node was successfully destroyed"
  end
end
