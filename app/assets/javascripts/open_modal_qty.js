$('#modal').html('#{escape_javascript(<%=render partial: "layouts/menu", locals: {product_id:@product_id,pack_id:@pack_id})}');