function findJsonElementById(data, id) {
    for (var i = 0; i < data.length; i++) {
        if (data[i].id == id) {
            return data[i].name_ru;
        }
        else {
            if (data[i].subcategories !== undefined) {
                var result = findJsonElementById(data[i].subcategories, id);

                if (result !== undefined) {
                    return result;
                }
            }
        }
    }
}