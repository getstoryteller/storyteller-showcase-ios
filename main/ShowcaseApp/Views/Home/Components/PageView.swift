import Foundation
import SwiftUI

struct FeedPageView: UIViewControllerRepresentable {
    var pagesViewModel: [FeedItemsViewModel]
    var moveToOriginTab: () -> Void
    var reload: () -> Void
    @Binding var currentPage: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator


        return pageViewController
    }

    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let direction: UIPageViewController.NavigationDirection = currentPage > context.coordinator.lastSelectedIndex ? .forward : .reverse
        if context.coordinator.lastSelectedIndex == currentPage && pagesViewModel[currentPage] != context.coordinator.pagesViewModel[currentPage] {
            context.coordinator.reloadData(on: currentPage, with: pagesViewModel[currentPage].feedItems)
            context.coordinator.pagesViewModel.remove(at: currentPage)
            context.coordinator.pagesViewModel.insert(pagesViewModel[currentPage], at: currentPage)
        } else if context.coordinator.lastSelectedIndex == currentPage {
            //case for swiping to the same
        } else {
            context.coordinator.lastSelectedIndex = currentPage
            pageViewController.setViewControllers([context.coordinator.controllers[currentPage]], direction: direction, animated: true)
        }
    }


    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: FeedPageView
        var pagesViewModel: [FeedItemsViewModel]
        var controllers = [UIViewController]()
        var lastSelectedIndex = -1

        init(_ parent: FeedPageView) {
            self.parent = parent
            self.pagesViewModel = parent.pagesViewModel
            controllers = parent.pagesViewModel.map { UIHostingController(rootView: FeedItemsView(viewModel: $0, moveToOriginTab: parent.moveToOriginTab, reload: parent.reload)) }
        }
        
        func reloadData(on index: Int, with items: FeedItems ) {
            if let controller = controllers[index] as? UIHostingController<FeedItemsView> {
                controller.rootView.viewModel.reload(items: items)
            }
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return nil
            }
            return controllers[index - 1]
        }


        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == controllers.count {
                return nil
            }
            return controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            if let visibleViewController = pendingViewControllers.first,
               let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }


        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = controllers.firstIndex(of: visibleViewController),
                parent.currentPage != index {
                lastSelectedIndex = index
                parent.currentPage = index
            } else if finished && !completed,
                let visibleViewController = previousViewControllers.first,
                let index = controllers.firstIndex(of: visibleViewController),
                parent.currentPage != index {
                lastSelectedIndex = index
                parent.currentPage = index
            }
        }
    }
}

