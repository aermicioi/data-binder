module aermicioi.test.binder.binder;

import aermicioi.binder;

unittest {
	string binded = "a integer";
	auto model = binded.bind;
	auto view = model.tbind;
    auto second = model.tbind;
    
	model = "a string";
	assert(model == binded);
	assert(model == view);
    assert(second == model);

	model = "another string";
	view = "totaly another string";
}