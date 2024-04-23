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
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let direction: UIPageViewController.NavigationDirection = currentPage > context.coordinator.lastSelectedIndex ? .forward : .reverse

        if context.coordinator.pagesViewModel != pagesViewModel {
            context.coordinator.pagesViewModel = pagesViewModel
            context.coordinator.resetControllers()
            pageViewController.setViewControllers([context.coordinator.controllers[currentPage]], direction: direction, animated: false)
        }

        if context.coordinator.lastSelectedIndex != currentPage {
            context.coordinator.lastSelectedIndex = currentPage
            pageViewController.setViewControllers([context.coordinator.controllers[currentPage]], direction: direction, animated: true)
        }
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        // Although the parent is always recreated by SwiftUI, we're storing it
        // so that we have access to its callbacks which don't change, and currentPage which is a binding,
        // so it persists across instances.
        var parent: FeedPageView
        var pagesViewModel: [FeedItemsViewModel]
        var controllers = [UIViewController]()
        var lastSelectedIndex = -1

        init(_ parent: FeedPageView) {
            self.parent = parent
            pagesViewModel = parent.pagesViewModel
            super.init()
            resetControllers()
        }

        func resetControllers() {
            controllers = pagesViewModel.map {
                UIHostingController(rootView: FeedItemsView(viewModel: $0, moveToOriginTab: parent.moveToOriginTab, reload: parent.reload))
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

