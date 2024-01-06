
pub fn egg_drop(eggs: usize, floors: usize) -> usize {
    let mut nd = vec![vec![0; floors + 1]; eggs + 1];

    for i in 0..=eggs {
        nd[i][0] = 0;
        nd[i][1] =1;
    }

    for i in 0..=floors {
        nd[1][i] = i;
    }

    for i in 2..=eggs {
        for j in 2..=floors {
            nd[i][j] = std::usize::MAX; 
            for k in 1..=j {
                let res = 1 + std::cmp::max(nd[i-1][k-1], nd[i][j-k]);
                if res < nd[i][j] {
                    nd[i][j] = res;
                }
            }
        }
    }
    nd[eggs][floors]
}

#[cfg(test)]
mod tests {
    use super::egg_drop;
    #[test]
    fn large_floors() {
        assert_eq!(egg_drop(2, 100), 14);
    }

    #[test]
    fn one_egg() {
        assert_eq!(egg_drop(1, 8), 8);
    }

    #[test]
    fn eggs2_floors2() {
        assert_eq!(egg_drop(2, 2), 2);
    }

    #[test]
    fn eggs3_floors5() {
        assert_eq!(egg_drop(3, 5), 3);
    }
}