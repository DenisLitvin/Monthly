//
//  ClipCollectionView.swift
//  ClipLayout
//
//  Created by Denis Litvin on 31.07.2018.
//

import UIKit
import FlexLayout

public class CollectionView<Cell: ViewModelBinder, Header: ViewModelBinder, Footer: ViewModelBinder>:
    UICollectionView,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
    where
    Cell: UICollectionViewCell,
    Header: UICollectionReusableView,
    Footer: UICollectionReusableView
{
    public var footerEnabled = false
    public var headerEnabled = false
    
    public var cellData: [[Cell.ViewModel]] = []
    public var headerData: [Header.ViewModel] = []
    public var footerData: [Footer.ViewModel] = []
    
    public var maxCellSize = CGSize(width: 0, height: 10000)
    public var maxHeaderSize = CGSize(width: 0, height: 10000)
    public var maxFooterSize = CGSize(width: 0, height: 10000)
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let footerId = "footerId"
    
    private let manequinCell = Cell()
    private let manequinHeader = Header()
    private let manequinFooter = Footer()
    
    public init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        register(Cell.self, forCellWithReuseIdentifier: cellId)
        register(Header.self,
                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                 withReuseIdentifier: headerId)
        register(Footer.self,
                 forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                 withReuseIdentifier: footerId)
        self.dataSource = self
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellData.count
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             numberOfItemsInSection section: Int) -> Int {
        return cellData[section].count
    }
    
    //MARK: - CELLS
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        manequinCell.set(viewModel: cellData[indexPath.section][indexPath.row])
        
        let finalMaxSize = CGSize(
            width: maxCellSize.width == 0 ? collectionView.bounds.width : maxCellSize.width,
            height: maxCellSize.height
        )
        
        let size = manequinCell.sizeThatFits(finalMaxSize)
        manequinCell.flex.markDirty()
        return size
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                         for: indexPath) as? Cell {
            cell.set(viewModel: cellData[indexPath.section][indexPath.row])
            return cell
        }
        
        fatalError("Could not dequeue reusable cell")
    }
    
    //MARK: - HEADER & FOOTER
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        guard headerEnabled else { return .zero }
        manequinHeader.set(viewModel: headerData[section])
        
        var finalMaxSize = CGSize(
            width: maxHeaderSize.width == 0 ? collectionView.bounds.width : maxHeaderSize.width,
            height: maxHeaderSize.height
        )
        adjustForScrollDirection(size: &finalMaxSize, for: collectionViewLayout, in: collectionView)
        let size = manequinHeader.sizeThatFits(finalMaxSize)
        manequinHeader.flex.markDirty()
        return size
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard footerEnabled else { return .zero }
        manequinFooter.set(viewModel: footerData[section])
        
        var finalMaxSize = CGSize(
            width: maxFooterSize.width == 0 ? collectionView.bounds.width : maxFooterSize.width,
            height: maxFooterSize.height
        )
        adjustForScrollDirection(size: &finalMaxSize, for: collectionViewLayout, in: collectionView)
        let size = manequinFooter.sizeThatFits(finalMaxSize)
        manequinFooter.flex.markDirty()
        return size
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             viewForSupplementaryElementOfKind kind: String,
                             at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: headerId,
                                                                         for: indexPath) as? Header {
            header.set(viewModel: headerData[indexPath.row])
            return header
        }
        
        if let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                        withReuseIdentifier: footerId,
                                                                        for: indexPath) as? Footer {
            footer.set(viewModel: footerData[indexPath.row])
            return footer
        }
        
        fatalError("Could not dequeue reusable supplementary view")
    }
    
    //MARK: - PRIVATE
    private func adjustForScrollDirection(size: inout CGSize,
                                          for collectionViewLayout: UICollectionViewLayout,
                                          in collectionView: UICollectionView) {
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            if layout.scrollDirection == .vertical {
                size.width = collectionView.bounds.width
            }
            else if layout.scrollDirection == .horizontal {
                size.height = collectionView.bounds.height
            }
        }
    }
}
