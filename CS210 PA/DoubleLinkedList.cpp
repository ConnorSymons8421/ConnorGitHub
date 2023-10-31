#include <iostream>

using namespace std;

// Data Class : Holds all the data that goes inside the Node
class Data {
public:
    int value;
    string name;
    Data(int value, string name) {
        this->value = value;
        this->name = name;
    }
    void print() {

        cout << value << " " << endl;
        cout << name << " " << endl;
    }
    bool compareData(Data* data) {
        return (value == data->value) && (name == data->name);
    }
};

// Node Class : Node for the LinkedList
template <typename T> class Node {
public:
    T *value;
    Node<T> *next;
    Node<T> *prev;
    Node(T *value) {
        this->value = value;
        next = nullptr;
        prev = nullptr;
    }
    void print() { value->print(); }
};

// LinkedList Class : Container for Nodes
template <typename T> class DoubleLinkedList {
private:
    Node<T> *head;
    Node<T> *tail;
    int length;

public:
    // Constructors
    DoubleLinkedList() {
        head = nullptr;
        tail = nullptr;
        length = 0;
    }

    DoubleLinkedList(T *value) {
        Node<T> *newNode = new Node<T>(value);
        head = newNode;
        tail = newNode;
        length = 1;
    }

    // Destructor
    ~DoubleLinkedList() {
        Node<T> *temp = head;
        while (head) {
            head = head->next;
            delete temp;
            temp = head;
        }
    }

    void printList() {
        Node<T> *temp = head;
        while (temp != nullptr) {
            temp->print();
            temp = temp->next;
        }
    }

    // get and set
    Node<T> *getHead() {
        if (head == nullptr) {
            cout << "Head: nullptr" << endl;
        } else {
            cout << "Head: " << head->value << endl;
        }
        return head;
    }

    Node<T> *getTail() {
        if (tail == nullptr) {
            cout << "Tail: nullptr" << endl;
        } else {
            cout << "Tail: " << tail->value << endl;
        }
        return tail;
    }

    int getLength() {
        cout << "Length: " << length << endl;
        return length;
    }

    Node<T> *get(int index) {
        if (index < 0 || index >= length)
            return nullptr;
        Node<T> *temp = head;
        for (int i = 0; i < index; ++i) {
            temp = temp->next;
        }
        return temp;
    }

    bool set(int index, T *value) {
        Node<T> *temp = get(index);
        if (temp) {
            temp->value = value;
            return true;
        }
        return false;
    }

    // All insert methods
    // Insert at end
    void append(T *value) {
        Node<T> *newNode = new Node<T>(value);
        if (length == 0) {
            head = newNode;
            tail = newNode;
        } else {
            tail->next = newNode;
            newNode->prev = tail;
            tail = newNode;
        }
        length++;
    }

    // Insert at beginning

    void prepend(T *value) {
        Node<T> *newNode = new Node<T>(value);
        if (length == 0) {
            head = newNode;
            tail = newNode;
        } else {
            newNode->next = head;
            head->prev = newNode;
            head = newNode;
        }
        length++;
    }

    // Insert at Index

    bool insert(int index, T *value) {
        if (index < 0 || index > length)
            return false;
        if (index == 0) {
            prepend(value);
            return true;
        }
        if (index == length) {
            append(value);
            return true;
        }
        Node<T> *newNode = new Node<T>(value);
        Node<T> *prev1 = get(index - 1);
        Node<T> *next1 = prev1->next;
        newNode->prev = prev1;
        newNode->next = next1;
        prev1->next = newNode;
        next1->prev = newNode;
        length++;
        return true;
    }

    // All delete Methods
    // Delete Head
    void deleteAtHead() {
        if(length == 0) {
            return;
        }
        head->print();
        if(length == 1) {
            delete head;
            head = nullptr;
            tail = nullptr;
            length--;
            return;
        }
        Node<T> *temp = head->next;
        temp->prev = nullptr;
        delete head;
        head = temp;
        length--;
    }

    //Delete Tail
    void deleteAtTail() {
        if(length == 0) {
            return;
        }
        if(length == 1) {
            delete head;
            head = nullptr;
            tail = nullptr;
            length--;
            return;
        }
        tail->print();
        Node<T> *temp = tail->prev;
        temp->next = nullptr;
        delete tail;
        tail = temp;
        length--;
    }

    //Delete At Index
    void deleteAtIndex(int index) {
        if (index < 0 || index > length)
            return;
        if(index == 0) {
            deleteAtHead();
            return;
        }
        if(index == length-1) {
            deleteAtTail();
            return;
        }
        if(length == 1) {
            delete head;
            head = nullptr;
            tail = nullptr;
            length--;
            return;
        }
        Node<T> *temp = get(index);
        Node<T> *prev1 = temp->prev;
        Node<T> *next1 = temp->next;
        temp->print();
        prev1->next = next1;
        next1->prev = prev1;
        delete temp;
        length--;
    }

    // Helper Delete Head No Print
    void deleteHead() {
        if(length == 0) {
            return;
        }
        if(length == 1) {
            delete head;
            head = nullptr;
            tail = nullptr;
            length--;
            return;
        }
        Node<T> *temp = head->next;
        temp->prev = nullptr;
        delete head;
        head = temp;
        length--;
    }

    // Helper Delete Tail No Print
    void deleteTail() {
        if(length == 0) {
            return;
        }
        if(length == 1) {
            delete head;
            head = nullptr;
            tail = nullptr;
            length--;
            return;
        }
        Node<T> *temp = tail->prev;
        temp->next = nullptr;
        delete tail;
        tail = temp;
        length--;
    }

    // Helper Delete at Index No Print
    void deleteIndex(int index) {
        if (index < 0 || index > length)
            return;
        if(index == 0) {
            deleteHead();
            return;
        }
        if(index == length-1) {
            deleteTail();
            return;
        }
        if(length == 1) {
            delete head;
            head = nullptr;
            tail = nullptr;
            length--;
            return;
        }
        Node<T> *temp = get(index);
        Node<T> *prev1 = temp->prev;
        Node<T> *next1 = temp->next;
        prev1->next = next1;
        next1->prev = prev1;
        delete temp;
        length--;
    }

    //Sort Method
    void sortList() {
        for(int i = length; i > 0; i--) {
            Node<T> *temp;
            Node<T> *next1;
            Node<T> *next2;
            Node<T> *prev1;
            for(int j = 0; j < i - 1; j++) {
                temp = get(j);
                next1 = temp->next;
                if(temp->value->value > next1->value->value) {
                    if(j == 0) {
                        next2 = next1->next;
                        next2->prev = temp;
                        next1->next = temp;
                        next1->prev = nullptr;
                        temp->next = next2;
                        temp->prev = next1;
                        head = next1;
                        continue;
                    }
                    if(j == length - 2) {
                        prev1 = temp->prev;
                        prev1->next = next1;
                        next1->prev = prev1;
                        next1->next = temp;
                        temp->next = nullptr;
                        temp->prev = next1;
                        tail = temp;
                        continue;
                    }
                    prev1 = temp->prev;
                    next2 = next1->next;
                    prev1->next = next1;
                    next1->prev = prev1;
                    next1->next = temp;
                    temp->next = next2;
                    temp->prev = next1;
                    next2->prev = temp;
                }
            }
        }
        printList();
    }

    //Remove nodes with matching data
    void removeMultiples() {
        Node<T> *temp1;
        Node<T> *temp2;
        bool duplicate = false;
        for(int i = 0; i < length-1; i++) {
            temp1 = get(i);
            for(int j= i + 1; j < length; j++) {
                temp2 = get(j);
                if(temp1->value->compareData(temp2->value)){
                    deleteIndex(j);
                    duplicate = true;
                    j--;
                }
            }
            if(duplicate) {
                deleteIndex(i);
                duplicate = false;
                i--;
            }
        }
        printList();
    }

    //Count nodes that match with the passed value
    int countMultiples(T* value) {
        int count = 0;
        Node<T> *temp;
        for(int i = 0; i < length; i++) {
            temp = get(i);
            if(temp->value->compareData(value)) {
                count++;
            }
        }
        return count;
    }

    //Split Linked List in half, new lists start from head/tail
    //Odd list lengths give middle node to the 'head list' A
    void headTailSplit() {
        if(length <= 0) {
            cout << "Original list is empty, no new lists created." << endl;
            delete this;
            return;
        }
        DoubleLinkedList<T> *listA = new DoubleLinkedList<T>(head->value);
        if(length == 1) {
            cout << "List A: " << endl;
            listA->printList();
            cout << "List B: Empty" << endl;
            delete this;
            return;
        }
        DoubleLinkedList<T> *listB = new DoubleLinkedList<T>(tail->value);
        int midpoint = (length % 2 == 0) ? (length/2 - 1) : ((length-1)/2); // number of iterations for list A
        this->deleteHead();
        for(int i = 0; i < midpoint; i++) {
            listA->append(head->value);
            this->deleteHead();
        }
        this->deleteTail();
        while(length > 0) {
            listB->append(tail->value);
            this->deleteTail();
        }
        cout << "List A:" << endl;
        listA->printList();
        cout << "List B:" << endl;
        listB->printList();
        delete this;
    }

    //Reverses Linked List
    void reverseList() {
        if(length <= 1) {
            return;
        }
        Node<T> *curr, *prev1, *next1;
        prev1 = nullptr;
        curr = head;
        while(curr != nullptr) {
            next1 = curr->next;
            curr->next = prev1;
            curr->prev = next1;
            prev1 = curr;
            curr = next1;
        }
        head = prev1;
        tail = get(length-1);
        printList();
    }
};

// Main Program

int main() {
    // Creating Linked List and local variables
    DoubleLinkedList<Data> *ll1 = new DoubleLinkedList<Data>();
    int userInput;
    int value;
    int index;
    int count;
    bool loop = true;
    string name;
    Data *dummyNode;
    // Calling operations on Linked List
    do {
        cout << "Please enter a valid integer (1-13): ";
        cin >> userInput;
        cout << endl;
        switch (userInput) {
            case 1:
                delete ll1;
                loop = false;
                break;
            case 2:
                cout << "Enter value: ";
                cin >> value;
                cout << "Enter name: ";
                cin >> name;
                dummyNode = new Data(value, name);
                ll1->prepend(dummyNode);
                break;
            case 3:
                cout << "Enter value: ";
                cin >> value;
                cout << "Enter name: ";
                cin >> name;
                dummyNode = new Data(value, name);
                ll1->append(dummyNode);
                break;
            case 4:
                cout << "Enter value: ";
                cin >> value;
                cout << "Enter name: ";
                cin >> name;
                cout << "Enter index: ";
                cin >> index;
                dummyNode = new Data(value, name);
                ll1->insert(index, dummyNode);
                break;
            case 5:
                ll1->deleteAtHead();
                break;
            case 6:
                ll1->deleteAtTail();
                break;
            case 7:
                cout << "Enter index: ";
                cin >> index;
                ll1->deleteAtIndex(index);
                break;
            case 8:
                ll1->reverseList();
                break;
            case 9:
                ll1->sortList();
                break;
            case 10:
                cout << "Enter value: ";
                cin >> value;
                cout << "Enter name: ";
                cin >> name;
                dummyNode = new Data(value, name);
                count = ll1->countMultiples(dummyNode);
                cout << "There were " << count << " node(s) that matched with that value and name" << endl;
                break;
            case 11:
                ll1->removeMultiples();
                break;
            case 12:
                ll1->headTailSplit();
                loop = false;
                break;
            case 13:
                loop = false;
                break;
            default:
                cout << "Invalid input, please try again" << endl;
                break;
        }
    } while(loop);

    return 0;
}
