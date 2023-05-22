$('#donateForm').submit(function() {
    const group = $('#donateForm-sum');
    const errorText = $('#donateForm-sum > .help-block');
    const input = $('#donateForm-sum > input')[0];
    const value = parseFloat(input.value);
    if (isNaN(value) || value < 0) {
        group.addClass('has-error');
        errorText.removeClass('hidden');
        return false;
    }
    else {
        group.removeClass('has-error');
        errorText.addClass('hidden');
        return true;
    }
});