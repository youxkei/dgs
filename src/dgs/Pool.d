module dgs.Pool;

struct Pool(E){
	invariant(){
		assert(_length >= 0);
		assert(_backLength >= 0);
	}

	this(lazy E value, in int length)in{
		assert(length > 0);
	}body{
		foreach(i; 0..length){
			addToBack(new Elem(value));
		}
	}

	@property E get(){
		if(!_backLength) {
			throw new Exception("size is over");
		}
		return addToFront(pickFromBack(_backEnd)).value;
	}

	int opApply(int delegate(ref bool, ref E) dg){
		int result = 0;
		if(!_length) return result;
		Elem elem = _first;
		while(1){
			bool del = false;
			result = dg(del, elem.value);
			if(result) break;
			Elem next = elem.n;
			if(del) addToBack(pickFromFront(elem));
			if(next is null) break; else elem = next;
		}
		return result;
	}

	@property int length()const{
		return _length;
	}

private:
	Elem _first;
	Elem _end;
	int _length;

	Elem _backFirst;
	Elem _backEnd;
	int _backLength;

	final class Elem{
		this(E e){
			value = e;
		}

		E value;
		Elem p;
		Elem n;
	}

	void connect(Elem a, Elem b){
		if(a !is null) a.n = b;
		if(b !is null) b.p = a;
	}

	//Frontの最後に追加。
	Elem addToFront(Elem elem){
		elem.p = null;
		elem.n = null;
		if(_length){
			connect(_end, elem);
		}else{
			_first = elem;
		}
		_end = elem;
		_length++;
		return elem;
	}

	//Backの最後に追加。
	Elem addToBack(Elem elem){
		elem.p = null;
		elem.n = null;
		if(_backLength){
			connect(_backEnd, elem);
		}else{
			_backFirst = elem;
		}
		_backEnd = elem;
		_backLength++;
		return elem;
	}

	//Frontから取る。
	Elem pickFromFront(Elem elem){
		if(elem.p is null){
			_first = elem.n;
			if(_first !is null){
				_first.p = null;
			}
		}else{
			elem.p.n = elem.n;
		}
		if(elem.n is null){
			_end = elem.p;
			if(_end !is null){
				_end.n = null;
			}
		}else{
			elem.n.p = elem.p;
		}
		_length--;
		return elem;
	}

	//Backから取る。
	Elem pickFromBack(Elem elem){
		if(elem.p is null){
			_backFirst = elem.n;
			if(_backFirst !is null){
				_backFirst.p = null;
			}
		}else{
			elem.p.n = elem.n;
		}
		if(elem.n is null){
			_backEnd = elem.p;
			if(_backEnd !is null){
				_backEnd.n = null;
			}
		}else{
			elem.n.p = elem.p;
		}
		_backLength--;
		return elem;
	}
}

unittest{
	class Hoge{
		int i;
	}
	auto p = Pool!(Hoge)(new Hoge(), 2);
	p.get().i = 10;
	p.get().i = 20;
	foreach(ref doRemove, hoge; p){
		doRemove = true;
	}
	assert(p.get().i == 20);
	assert(p.get().i == 10);
}
