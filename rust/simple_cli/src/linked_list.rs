#[derive(Debug)]
struct Node<T> {
    data: T,
    next: Option<Box<Node<T>>>,
}

#[derive(Debug)]
struct LinkedList<T> {
    head: Option<Box<Node<T>>>,
}

impl<T: std::fmt::Debug> LinkedList<T> {
    fn new() -> Self {
        LinkedList { head: None }
    }

    fn append(&mut self, data: T) {
        let head = self.head.take();
        self.head = Some(Box::new(Node{data: data, next: head}));
    }

    fn pop(&mut self) -> Option<T> {
        let head = self.head.take();
        if self.head.is_none() {
            println!("self.head is None");
        }
        match head {
            None => {
                self.head = None;
                None
            },
            Some(mut node) => {
                self.head = node.next.take();
                Some(node.data)
            }
        }
    }

    fn print(&self) {
        let mut node = &self.head;
        while let Some(n) = node {
            println!("data = {:?}", n.data);
            node = &n.next;
        }
    }
}


fn main() {
    let mut list = LinkedList::new();
    list.append("foo");
    list.append("boo");
    list.append("moo");
    list.print();

    let v = list.pop();
    println!("v = {:?}", v.unwrap());
    list.print();
}
