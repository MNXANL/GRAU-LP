// C++11 code
#include <iostream>
#include <map>
#include <functional>

using namespace std;

template<class entr, class sort>


function<sort(entr)> memoize(function<sort(entr)> f) {
    map<entr, sort> m;
    return [=](entr x) mutable -> sort {
        auto it = m.find(x);
        if (it == m.end()) return m[x] = f(x);
          return it->second;
    };
};

int main(int argc, char** argv) {
    function<int(int)> fib = [&](int n) -> int {
        if (n < 2) return n;
        return fib(n - 1) + fib(n - 2);
    };
    fib = memoize(fib);
    for (int i = 0; i < 100; ++i) {
        cout << i << ": " << fib(i) << endl;
    }
}
